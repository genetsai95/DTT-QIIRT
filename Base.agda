-- {-# OPTIONS --cubical --exact-split #-}
{-# OPTIONS --exact-split --rewriting -vtc.cover.splittree:10 #-}
module DTT-QIIRT.Base where

-- open import Cubical.Core.Primitives
open import Agda.Builtin.Equality.Rewrite
open import Relation.Binary.PropositionalEquality as Eq
  using (_≡_; refl; subst; sym; cong; cong₂; module ≡-Reasoning)
open ≡-Reasoning

-- inductive-inductive-recursive definition of context, type, term, and type substitution

infixl 35 _[_] _[_]t _[_]tm
infix  30 ƛ_ _·vz
infix  20 _‣_

data Ctx : Set
data Ty  : Ctx → Set
data Tm  : (Γ : Ctx) → Ty Γ → Set
data Sub : Ctx → Ctx → Set

_[_]  : ∀{Δ Γ} → Ty Γ → Sub Δ Γ → Ty Δ
 
variable
    Γ Γ' Γ'' Δ Δ' Θ Θ' Φ : Ctx
    A A' A'' B B' B'' : Ty Γ
    t t' s s' : Tm Γ A

data Ctx where
  ∅
    : Ctx
  _‣_
    : (Γ : Ctx) (A : Ty Γ)
    → Ctx

data Sub where
  ∅
    ---------
    : Sub Δ ∅
  _‣_
    : (σ : Sub Δ Γ) (t : Tm Δ (A [ σ ]))
    ---------------------------------
    → Sub Δ (Γ ‣ A)
  idS
    : Sub Δ Δ
  _⨾_
    : {Γ Δ Θ : Ctx}
    → (σ : Sub Δ Γ) (δ : Sub Θ Δ)
    → Sub Θ Γ
  π₁
   : (σ : Sub Δ (Γ ‣ A))
   → Sub Δ Γ

data Ty where
  U
    : Ty Γ
  El
    : (u : Tm Γ U)
    --------------
    → Ty Γ
  Π
    : (A : Ty Γ) (B : Ty (Γ ‣ A))
    ------------------------------
    → Ty Γ

data Tm where
  π₂
    : (σ : Sub Δ (Γ ‣ A))
    → Tm Δ (A [ π₁ σ ])
  ƛ_
    : Tm (Γ ‣ A) B
    → Tm Γ (Π A B)
  _·vz
    : Tm Γ (Π A B)
    → Tm (Γ ‣ A) B
  _[_]tm
    : Tm Γ A → (σ : Sub Δ Γ)
    → Tm Δ (A [ σ ])

-- type substitution as recursion
-- pattern matching on types first
_↑_ : (σ : Sub Δ Γ)(A : Ty Γ) → Sub (Δ ‣ A [ σ ]) (Γ ‣ A)

{-# TERMINATING #-}
U [ σ ]        = U

El u [ idS ]   = El u
El u [ σ ⨾ τ ] = El u [ σ ] [ τ ]
El u [ σ ]     = El (u [ σ ]tm)

Π A B [ idS ]   = Π A B
Π A B [ σ ⨾ τ ] = Π A B [ σ ] [ τ ]
Π A B [ σ ]     = Π (A [ σ ]) (B [ σ ↑ A ])

σ ↑ U     = (σ ⨾ π₁ idS) ‣ π₂ idS
σ ↑ El _  = (σ ⨾ π₁ idS) ‣ π₂ idS
σ ↑ Π _ _ = (σ ⨾ π₁ idS) ‣ π₂ idS

-- equalities of types
_[idS] : (A : Ty Γ) → A [ idS ] ≡ A
U     [idS] = refl
El u  [idS] = refl
Π A B [idS] = refl

_[⨾] : (A : Ty Γ){σ : Sub Δ Γ}{τ : Sub Θ Δ} → A [ σ ⨾ τ ] ≡ A [ σ ] [ τ ]
U     [⨾] = refl
El u  [⨾] = refl
Π A B [⨾] = refl

{-# REWRITE _[idS] _[⨾] #-}

_[_]t : {Γ Δ : Ctx} {A : Ty Γ} (t : Tm Γ A) (σ : Sub Δ Γ)
  → Tm Δ (A [ σ ])

t [ idS   ]t  = t
t [ σ ⨾ τ ]t  = t [ σ ]t [ τ ]t
t [ ∅ ]t      = t [ ∅ ]tm
t [ σ ‣ τ ]t  = t [ σ ‣ τ ]tm
t [ π₁ σ ]t   = t [ π₁ σ ]tm

-- -- equalities for type substitution
-- -- pattern matching on substitutions first
-- 
-- {-# TERMINATING #-}
-- A [ idS   ]     = A
-- A [ σ ⨾ τ ]     = A [ σ ] [ τ ]
-- U     [ ∅ ]     = U
-- El u  [ ∅ ]     = El (u [ ∅ ]t)
-- Π A B [ ∅ ]     = Π (A [ ∅ ]) (B [ ∅ ↑ A ])
-- U     [ σ ‣ t ] = U
-- El u  [ σ ‣ t ] = El (u [ σ ‣ t ]t)
-- Π A B [ σ ‣ t ] = Π (A [ σ ‣ t ]) (B [ (σ ‣ t) ↑ A ])
-- U     [ π₁ σ ]  = U
-- El u  [ π₁ σ ]  = El (u [ π₁ σ ]t)
-- Π A B [ π₁ σ ]  = Π (A [ π₁ σ ]) (B [ π₁ σ ↑ A ])
-- 
-- σ ↑ A = (σ ⨾ π₁ idS) ‣ π₂ idS
-- 
-- t [ idS   ]t  = t
-- t [ σ ⨾ τ ]t  = t [ σ ]t [ τ ]t
-- t [ ∅ ]t      = t [ ∅ ]tm
-- t [ σ ‣ τ ]t  = t [ σ ‣ τ ]tm
-- t [ π₁ σ ]t   = t [ π₁ σ ]tm
-- 
-- U[σ]=U : (σ : Sub Γ Δ)
--   → U [ σ ] ≡ U
-- U[σ]=U ∅       = refl
-- U[σ]=U (σ ‣ t) = refl
-- U[σ]=U idS     = refl
-- U[σ]=U (σ ⨾ τ) =
--   U [ σ ] [ τ ]
--     ≡⟨  cong (_[ τ ]) (U[σ]=U σ) ⟩
--   U [ τ ]
--     ≡⟨ U[σ]=U τ ⟩
--   U
--     ∎
-- U[σ]=U (π₁ σ)  = refl
-- 
-- {-# REWRITE U[σ]=U #-}
-- 
El[σ] : (u : Tm Γ U) (σ : Sub Δ Γ)
  → El u [ σ ] ≡ El (u [ σ ]t)
El[σ] u idS     = refl
El[σ] u (_⨾_ {Γ} {Δ} {Θ} σ τ) =
  El u [ σ ] [ τ ]
    ≡⟨ (cong (_[ τ ])) (El[σ] u σ) ⟩
  El (u [ σ ]t) [ τ ]
    ≡⟨ El[σ] (u [ σ ]t) τ ⟩
  El (u [ σ ]t [ τ ]t)
    ∎
El[σ] u ∅       = refl
El[σ] u (σ ‣ t) = refl
El[σ] u (π₁ σ)  = refl
 
-- {-# REWRITE El[σ] #-}

-- equalities of substitutions
postulate
  idS⨾_
    : (σ : Sub Δ Γ)
    → idS ⨾ σ ≡ σ
  _⨾idS
    : (σ : Sub Δ Γ)
    → σ ⨾ idS ≡ σ
  assocS
    : {σ : Sub Δ Γ}{τ : Sub Θ Δ}{υ : Sub Φ Θ}
    → (σ ⨾ τ) ⨾ υ ≡ σ ⨾ (τ ⨾ υ)
  ‣⨾
    : {σ : Sub Δ Γ}{t : Tm Δ (A [ σ ])}{τ : Sub Θ Δ}
    → (_‣_ {A = A} σ t) ⨾ τ ≡ (σ ⨾ τ) ‣ t [ τ ]t
  βπ₁
    : {σ : Sub Δ Γ}{t : Tm Δ (A [ σ ])}
    → π₁ (_‣_ {A = A} σ t) ≡ σ
  ηπ
    : {σ : Sub Δ (Γ ‣ A)}
    → π₁ σ ‣ π₂ σ ≡ σ
  η∅
    : {σ : Sub Δ ∅}
    → σ ≡ ∅

idS↑ : (A : Ty Γ) → idS ↑ A ≡ idS
idS↑ U       =
    (idS ⨾ π₁ idS) ‣ π₂ idS
  ≡⟨ cong (_‣ π₂ idS) (idS⨾ π₁ idS) ⟩
      π₁ idS ‣ π₂ idS
  ≡⟨ ηπ ⟩
      idS
  ∎
idS↑ (El u) =
    (idS ⨾ π₁ idS) ‣ π₂ idS
  ≡⟨ {!!} ⟩
      π₁ idS ‣ π₂ idS
  ≡⟨ ηπ ⟩
      idS
  ∎
idS↑ (Π A B) =
    (idS ⨾ π₁ idS) ‣ π₂ idS
  ≡⟨ {!!} ⟩
      π₁ idS ‣ π₂ idS
  ≡⟨ ηπ ⟩
      idS
  ∎
{-# REWRITE idS↑ #-}

Π[] : {A : Ty Γ}{B : Ty (Γ ‣ A)}(σ : Sub Δ Γ)
  → Π A B [ σ ] ≡ Π (A [ σ ]) (B [ σ ↑ A ])
Π[] idS     = refl 
Π[] (σ ⨾ τ) = {!   !}
Π[] ∅       = refl
Π[] (σ ‣ t) = refl
Π[] (π₁ σ)  = refl

-- common syntax
wk : Sub (Δ ‣ A) Δ
wk = π₁ idS

vz : Tm (Γ ‣ A) (A [ wk ])
vz = π₂ idS

vs : Tm Γ A → Tm (Γ ‣ B) (A [ wk ])
vs x = x [ wk ]t

vz:= : Tm Γ A → Sub Γ (Γ ‣ A)
vz:= {Γ} {A} t = idS ‣ t

_·_ : Tm Γ (Π A B) → (s : Tm Γ A) → Tm Γ (B [ vz:= s ])
t · s = (t ·vz) [ vz:= s ]t

-- -- -- -- Use equality constructor instead or postulate
-- -- -- data _⟶⟨_⟩_ : Tm Γ A → A ≡ B → Tm Γ B → Set where
-- -- --     [idS] : t [ idS ] ⟶⟨ A [idS]ᵀ ⟩ t  -- subst (Tm Γ) (A [idS]ᵀ) (t [ idS ]) ⟶ t
-- -- --     [⨾] : {t : Tm Γ A}{σ : Sub Δ Γ}{τ : Sub Θ Δ} → (t [ σ ⨾ τ ]) ⟶⟨ A [⨾]ᵀ ⟩ t [ σ ] [ τ ] -- subst (Tm Θ) (A [⨾]ᵀ) (t [ σ ⨾ τ ]) ⟶ t [ σ ] [ τ ]
-- -- --     ƛ[] : {t : Tm (Γ ‣ A) B}{σ : Sub Δ Γ} → (ƛ t) [ σ ] ⟶⟨ Π[] {A = A} ⟩ ƛ t [ σ ↑ A ] -- subst (Tm Δ) (Π[] {A = A}) ((ƛ t) [ σ ]) ⟶ ƛ t [ σ ↑ A ]
-- -- --     βπ₂ : {σ : Sub Δ Γ}{t : Tm Δ (A [ σ ]ᵀ)} → π₂ (_‣_ {A = A} σ t) ⟶⟨ cong (A [_]ᵀ) βπ₁ ⟩ t -- subst (λ τ → Tm Δ (A [ τ ]ᵀ)) βπ₁ (π₂ (_‣_ {A = A} σ t)) ⟶ t
-- -- --     βΠ : {t : Tm (Γ ‣ A) B} → (ƛ t) ·vz ⟶⟨ refl ⟩ t
-- -- --     ηΠ : {t : Tm Γ (Π A B)} → ƛ (t ·vz) ⟶⟨ refl ⟩ t
