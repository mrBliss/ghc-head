%
% (c) The GRASP/AQUA Project, Glasgow University, 1992-1998
%
\section[Name]{@Name@: to transmit name info from renamer to typechecker}

\begin{code}
module Name (
	-- Re-export the OccName stuff
	module OccName,

	-- The Name type
	Name,					-- Abstract
	BuiltInSyntax(..), 
	mkInternalName, mkSystemName, 
	mkSystemNameEncoded, mkSysTvName, 
	mkFCallName, mkIPName,
	mkExternalName, mkWiredInName,

	nameUnique, setNameUnique,
	nameOccName, nameModule, nameModule_maybe, nameModuleName,
	setNameOcc, 
	hashName, localiseName,

	nameSrcLoc, nameParent, nameParent_maybe,

	isSystemName, isInternalName, isExternalName,
	isTyVarName, isDllName, isWiredInName, isBuiltInSyntax,
	wiredInNameTyThing_maybe, 
	nameIsLocalOrFrom, isHomePackageName,
	
	-- Class NamedThing and overloaded friends
	NamedThing(..),
	getSrcLoc, getOccString
    ) where

#include "HsVersions.h"

import {-# SOURCE #-} TypeRep( TyThing )

import OccName		-- All of it
import Module		( Module, ModuleName, moduleName, isHomeModule )
import CmdLineOpts	( opt_Static )
import SrcLoc		( noSrcLoc, wiredInSrcLoc, SrcLoc )
import Unique		( Unique, Uniquable(..), getKey, pprUnique )
import Maybes		( orElse )
import FastTypes
import Outputable
\end{code}

%************************************************************************
%*									*
\subsection[Name-datatype]{The @Name@ datatype, and name construction}
%*									*
%************************************************************************
 
\begin{code}
data Name = Name {
		n_sort :: NameSort,	-- What sort of name it is
		n_occ  :: !OccName,	-- Its occurrence name
		n_uniq :: Unique,
		n_loc  :: !SrcLoc	-- Definition site
	    }

-- NOTE: we make the n_loc field strict to eliminate some potential
-- (and real!) space leaks, due to the fact that we don't look at
-- the SrcLoc in a Name all that often.

data NameSort
  = External Module (Maybe Name)
	-- (Just parent) => this Name is a subordinate name of 'parent'
	-- e.g. data constructor of a data type, method of a class
	-- Nothing => not a subordinate
 
  | WiredIn Module (Maybe Name) TyThing BuiltInSyntax
	-- A variant of External, for wired-in things

  | Internal		-- A user-defined Id or TyVar
			-- defined in the module being compiled

  | System		-- A system-defined Id or TyVar.  Typically the
			-- OccName is very uninformative (like 's')

data BuiltInSyntax = BuiltInSyntax | UserSyntax
-- BuiltInSyntax is for things like (:), [], tuples etc, 
-- which have special syntactic forms.  They aren't "in scope"
-- as such.
\end{code}

Notes about the NameSorts:

1.  Initially, top-level Ids (including locally-defined ones) get External names, 
    and all other local Ids get Internal names

2.  Things with a External name are given C static labels, so they finally
    appear in the .o file's symbol table.  They appear in the symbol table
    in the form M.n.  If originally-local things have this property they
    must be made @External@ first.

3.  In the tidy-core phase, a External that is not visible to an importer
    is changed to Internal, and a Internal that is visible is changed to External

4.  A System Name differs in the following ways:
	a) has unique attached when printing dumps
	b) unifier eliminates sys tyvars in favour of user provs where possible

    Before anything gets printed in interface files or output code, it's
    fed through a 'tidy' processor, which zaps the OccNames to have
    unique names; and converts all sys-locals to user locals
    If any desugarer sys-locals have survived that far, they get changed to
    "ds1", "ds2", etc.

Built-in syntax => It's a syntactic form, not "in scope" (e.g. [])

Wired-in thing  => The thing (Id, TyCon) is fully known to the compiler, 
		   not read from an interface file. 
		   E.g. Bool, True, Int, Float, and many others

All built-in syntax is for wired-in things.

\begin{code}
nameUnique		:: Name -> Unique
nameOccName		:: Name -> OccName 
nameModule		:: Name -> Module
nameModuleName		:: Name -> ModuleName
nameSrcLoc		:: Name -> SrcLoc

nameUnique  name = n_uniq name
nameOccName name = n_occ  name
nameSrcLoc  name = n_loc  name
\end{code}

\begin{code}
nameIsLocalOrFrom :: Module -> Name -> Bool
isInternalName	  :: Name -> Bool
isExternalName	  :: Name -> Bool
isSystemName	  :: Name -> Bool
isHomePackageName :: Name -> Bool
isWiredInName	  :: Name -> Bool

isWiredInName (Name {n_sort = WiredIn _ _ _ _}) = True
isWiredInName other			        = False

wiredInNameTyThing_maybe :: Name -> Maybe TyThing
wiredInNameTyThing_maybe (Name {n_sort = WiredIn _ _ thing _}) = Just thing
wiredInNameTyThing_maybe other				       = Nothing

isBuiltInSyntax (Name {n_sort = WiredIn _ _ _ BuiltInSyntax}) = True
isBuiltInSyntax other			 		      = False

isExternalName (Name {n_sort = External _ _})    = True
isExternalName (Name {n_sort = WiredIn _ _ _ _}) = True
isExternalName other	                         = False

isInternalName name = not (isExternalName name)

nameParent_maybe :: Name -> Maybe Name
nameParent_maybe (Name {n_sort = External _ p})    = p
nameParent_maybe (Name {n_sort = WiredIn _ p _ _}) = p
nameParent_maybe other	                           = Nothing

nameParent :: Name -> Name
nameParent name = case nameParent_maybe name of
			Just parent -> parent
			Nothing     -> name

nameModule name = nameModule_maybe name `orElse` pprPanic "nameModule" (ppr name)
nameModuleName name = moduleName (nameModule name)

nameModule_maybe (Name { n_sort = External mod _})    = Just mod
nameModule_maybe (Name { n_sort = WiredIn mod _ _ _}) = Just mod
nameModule_maybe name				      = Nothing

nameIsLocalOrFrom from name
  | isExternalName name = from == nameModule name
  | otherwise		= True

isHomePackageName name
  | isExternalName name = isHomeModule (nameModule name)
  | otherwise		= True  	-- Internal and system names

isDllName :: Name -> Bool	-- Does this name refer to something in a different DLL?
isDllName nm = not opt_Static && not (isHomePackageName nm)

isTyVarName :: Name -> Bool
isTyVarName name = isTvOcc (nameOccName name)

isSystemName (Name {n_sort = System}) = True
isSystemName other		      = False
\end{code}


%************************************************************************
%*									*
\subsection{Making names}
%*									*
%************************************************************************

\begin{code}
mkInternalName :: Unique -> OccName -> SrcLoc -> Name
mkInternalName uniq occ loc = Name { n_uniq = uniq, n_sort = Internal, n_occ = occ, n_loc = loc }
	-- NB: You might worry that after lots of huffing and
	-- puffing we might end up with two local names with distinct
	-- uniques, but the same OccName.  Indeed we can, but that's ok
	--	* the insides of the compiler don't care: they use the Unique
	--	* when printing for -ddump-xxx you can switch on -dppr-debug to get the
	--	  uniques if you get confused
	--	* for interface files we tidyCore first, which puts the uniques
	--	  into the print name (see setNameVisibility below)

mkExternalName :: Unique -> Module -> OccName -> Maybe Name -> SrcLoc -> Name
mkExternalName uniq mod occ mb_parent loc 
  = Name { n_uniq = uniq, n_sort = External mod mb_parent,
           n_occ = occ, n_loc = loc }

mkWiredInName :: Module -> OccName -> Unique 
	      -> Maybe Name -> TyThing -> BuiltInSyntax -> Name
mkWiredInName mod occ uniq mb_parent thing built_in
  = Name { n_uniq = uniq,
	   n_sort = WiredIn mod mb_parent thing built_in,
	   n_occ = occ, n_loc = wiredInSrcLoc }

mkSystemName :: Unique -> UserFS -> Name
mkSystemName uniq fs = Name { n_uniq = uniq, n_sort = System, 
			      n_occ = mkVarOcc fs, n_loc = noSrcLoc }

-- Use this version when the string is already encoded.  Avoids duplicating
-- the string each time a new name is created.
mkSystemNameEncoded :: Unique -> EncodedFS -> Name
mkSystemNameEncoded uniq fs = Name { n_uniq = uniq, n_sort = System, 
			             n_occ = mkSysOccFS varName fs, 
				     n_loc = noSrcLoc }

mkSysTvName :: Unique -> EncodedFS -> Name
mkSysTvName uniq fs = Name { n_uniq = uniq, n_sort = System, 
		             n_occ = mkSysOccFS tvName fs, 
			     n_loc = noSrcLoc }

mkFCallName :: Unique -> EncodedString -> Name
	-- The encoded string completely describes the ccall
mkFCallName uniq str =  Name { n_uniq = uniq, n_sort = Internal, 
			       n_occ = mkFCallOcc str, n_loc = noSrcLoc }

mkIPName :: Unique -> OccName -> Name
mkIPName uniq occ
  = Name { n_uniq = uniq,
	   n_sort = Internal,
	   n_occ  = occ,
	   n_loc = noSrcLoc }
\end{code}

\begin{code}
-- When we renumber/rename things, we need to be
-- able to change a Name's Unique to match the cached
-- one in the thing it's the name of.  If you know what I mean.
setNameUnique name uniq = name {n_uniq = uniq}

setNameOcc :: Name -> OccName -> Name
setNameOcc name occ = name {n_occ = occ}

localiseName :: Name -> Name
localiseName n = n { n_sort = Internal }
\end{code}


%************************************************************************
%*									*
\subsection{Predicates and selectors}
%*									*
%************************************************************************

\begin{code}
hashName :: Name -> Int
hashName name = getKey (nameUnique name)
\end{code}


%************************************************************************
%*									*
\subsection[Name-instances]{Instance declarations}
%*									*
%************************************************************************

\begin{code}
cmpName n1 n2 = n_uniq n1 `compare` n_uniq n2
\end{code}

\begin{code}
instance Eq Name where
    a == b = case (a `compare` b) of { EQ -> True;  _ -> False }
    a /= b = case (a `compare` b) of { EQ -> False; _ -> True }

instance Ord Name where
    a <= b = case (a `compare` b) of { LT -> True;  EQ -> True;  GT -> False }
    a <	 b = case (a `compare` b) of { LT -> True;  EQ -> False; GT -> False }
    a >= b = case (a `compare` b) of { LT -> False; EQ -> True;  GT -> True  }
    a >	 b = case (a `compare` b) of { LT -> False; EQ -> False; GT -> True  }
    compare a b = cmpName a b

instance Uniquable Name where
    getUnique = nameUnique

instance NamedThing Name where
    getName n = n
\end{code}


%************************************************************************
%*									*
\subsection{Pretty printing}
%*									*
%************************************************************************

\begin{code}
instance Outputable Name where
	-- When printing interfaces, all Internals have been given nice print-names
    ppr name = pprName name

instance OutputableBndr Name where
    pprBndr _ name = pprName name

pprName (Name {n_sort = sort, n_uniq = uniq, n_occ = occ})
  = getPprStyle $ \ sty ->
    case sort of
      WiredIn mod _ _ BuiltInSyntax -> pprOccName occ	-- Built-in syntax is never qualified
      WiredIn mod _ _ UserSyntax    -> pprExternal sty uniq mod occ True
      External mod _  	            -> pprExternal sty uniq mod occ False
      System   		 	    -> pprSystem sty uniq occ
      Internal    	 	    -> pprInternal sty uniq occ

pprExternal sty uniq mod occ is_wired
  | unqualStyle sty mod_name occ = pprOccName occ
  | codeStyle sty        = ppr mod_name <> char '_' <> pprOccName occ
  | debugStyle sty       = sep [ppr mod_name <> dot <> pprOccName occ,
				hsep [text "{-" 
				     , if is_wired then ptext SLIT("(w)") else empty
				     , pprUnique uniq
-- (overkill)			     , case mb_p of
--				 	 Nothing -> empty
--					 Just n  -> brackets (ppr n)
				     , text "-}"]]
  | otherwise		 	 = ppr mod_name <> dot <> pprOccName occ
  where
    mod_name = moduleName mod

pprInternal sty uniq occ
  | codeStyle sty  = pprUnique uniq
  | debugStyle sty = pprOccName occ <> text "{-" <> pprUnique uniq <> text "-}"
  | otherwise      = pprOccName occ	-- User style

-- Like Internal, except that we only omit the unique in Iface style
pprSystem sty uniq occ
  | codeStyle sty  = pprUnique uniq
  | otherwise	   = pprOccName occ <> char '_' <> pprUnique uniq
				-- If the tidy phase hasn't run, the OccName
				-- is unlikely to be informative (like 's'),
				-- so print the unique
\end{code}

%************************************************************************
%*									*
\subsection{Overloaded functions related to Names}
%*									*
%************************************************************************

\begin{code}
class NamedThing a where
    getOccName :: a -> OccName
    getName    :: a -> Name

    getOccName n = nameOccName (getName n)	-- Default method
\end{code}

\begin{code}
getSrcLoc	    :: NamedThing a => a -> SrcLoc
getOccString	    :: NamedThing a => a -> String

getSrcLoc	    = nameSrcLoc	   . getName
getOccString 	    = occNameString	   . getOccName
\end{code}

