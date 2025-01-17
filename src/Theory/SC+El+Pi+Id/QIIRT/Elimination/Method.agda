-- Methods of Model of Substitution Calculus
open import Prelude

module Theory.SC+El+Pi+Id.QIIRT.Elimination.Method where

open import Theory.SC+El+Pi+Id.QIIRT.Syntax
open import Theory.SC+El+Pi+Id.QIIRT.Properties
open import Theory.SC+El+Pi+Id.QIIRT.Elimination.Motive

module _ {ℓ ℓ′}(Mot : Motive ℓ ℓ′) where
  open Motive Mot
  private variable
    Γᴹ Δᴹ Θᴹ : Ctxᴹ Γ
    σᴹ τᴹ γᴹ : Subᴹ Γᴹ Δᴹ σ
    Aᴹ Bᴹ Cᴹ : Tyᴹ Γᴹ A
    aᴹ tᴹ uᴹ : Tmᴹ Γᴹ Aᴹ t
    p : Tm Γ (Id a t u)

  record CwF : Set (ℓ ⊔ ℓ′) where
    field
      [_]ᴹ_
        : (σᴹ : Subᴹ Γᴹ Δᴹ σ)(Aᴹ : Tyᴹ Δᴹ A)
        → Tyᴹ Γᴹ ([ σ ] A)
      ∅ᶜᴹ
        : Ctxᴹ ∅
      _,ᶜᴹ_
        : (Γᴹ : Ctxᴹ Γ)(Aᴹ : Tyᴹ Γᴹ A)
        → Ctxᴹ (Γ , A)
      ∅ˢᴹ
        : Subᴹ Δᴹ ∅ᶜᴹ ∅
      _,ˢᴹ_
        : (σᴹ : Subᴹ Γᴹ Δᴹ σ)(tᴹ : Tmᴹ Γᴹ ([ σᴹ ]ᴹ Aᴹ) t)
        → Subᴹ Γᴹ (Δᴹ ,ᶜᴹ Aᴹ) (σ , t)
      idSᴹ
        : Subᴹ Γᴹ Γᴹ idS
      _⨟ᴹ_
        : (τᴹ : Subᴹ Γᴹ Δᴹ τ)(σᴹ : Subᴹ Δᴹ Θᴹ σ)
        → Subᴹ Γᴹ Θᴹ (τ ⨟ σ)
      π₁ᴹ
        : (σᴹ : Subᴹ Γᴹ (Δᴹ ,ᶜᴹ Aᴹ) σ)
        → Subᴹ Γᴹ Δᴹ (π₁ σ)
      [idSᴹ]
        : [ idSᴹ ]ᴹ Aᴹ ≡ Aᴹ
      [⨟ᴹ]ᴹ
        : [ σᴹ ⨟ᴹ τᴹ ]ᴹ Aᴹ ≡ [ σᴹ ]ᴹ ([ τᴹ ]ᴹ Aᴹ)
      [π₁ᴹ,ˢᴹ]ᴹ
        : ([ π₁ᴹ (σᴹ ,ˢᴹ tᴹ) ]ᴹ Aᴹ) ≡ [ σᴹ ]ᴹ Aᴹ
      [π₁ᴹ⨟ᴹ]ᴹ
        : [ π₁ᴹ (σᴹ ⨟ᴹ τᴹ) ]ᴹ Aᴹ ≡ [ σᴹ ]ᴹ ([ π₁ᴹ τᴹ ]ᴹ Aᴹ)
      π₂ᴹ
        : (σᴹ : Subᴹ Δᴹ (Γᴹ ,ᶜᴹ Aᴹ) σ)
        ---------------------------------
        → Tmᴹ Δᴹ ([ π₁ᴹ σᴹ ]ᴹ Aᴹ) (π₂ σ)
      [_]tmᴹ_
        : (σᴹ : Subᴹ Γᴹ Δᴹ σ) {Aᴹ : Tyᴹ Δᴹ A}
        → (tᴹ : Tmᴹ Δᴹ Aᴹ t)
        → Tmᴹ Γᴹ ([ σᴹ ]ᴹ Aᴹ) ([ σ ]tm t)
    
    _⁺ᴹ
      : (σᴹ : Subᴹ Γᴹ Δᴹ σ)
      → Subᴹ (Γᴹ ,ᶜᴹ ([ σᴹ ]ᴹ Aᴹ)) (Δᴹ ,ᶜᴹ Aᴹ) (σ ⁺)
    σᴹ ⁺ᴹ = (π₁ᴹ idSᴹ ⨟ᴹ σᴹ) ,ˢᴹ tr TmᴹFamₜ (sym $ [⨟ᴹ]ᴹ) (π₂ᴹ idSᴹ)

    Subᴹ,ᶜᴹFam
      : {Γᴹ : Ctxᴹ Γ} → {Ctxᴹ Δ} → {Sub (Γ , A) Δ} → Tyᴹ Γᴹ A → Set ℓ′
    Subᴹ,ᶜᴹFam {_} {_} {_} {Γᴹ} {Δᴹ} {σ} Aᴹ = Subᴹ (Γᴹ ,ᶜᴹ Aᴹ) Δᴹ σ

    field
      _↑ᴹ_
        : (σᴹ : Subᴹ Γᴹ Δᴹ σ)(Aᴹ : Tyᴹ Δᴹ A)
        → Subᴹ (Γᴹ ,ᶜᴹ ([ σᴹ ]ᴹ Aᴹ)) (Δᴹ ,ᶜᴹ Aᴹ) (σ ↑ A)

      idSᴹ↑ᴹ
        : tr Subᴹ,ᶜᴹFam [idSᴹ] (idSᴹ ↑ᴹ Aᴹ) ≡ idSᴹ
      ⨟ᴹ↑ᴹ
        : tr Subᴹ,ᶜᴹFam [⨟ᴹ]ᴹ ((σᴹ ⨟ᴹ τᴹ) ↑ᴹ Aᴹ)
        ≡ (σᴹ ↑ᴹ ([ τᴹ ]ᴹ Aᴹ)) ⨟ᴹ (τᴹ ↑ᴹ Aᴹ)
      π₁ᴹ,ˢᴹ↑ᴹ
        : tr Subᴹ,ᶜᴹFam [π₁ᴹ,ˢᴹ]ᴹ (π₁ᴹ (σᴹ ,ˢᴹ tᴹ) ↑ᴹ Aᴹ)
        ≡ σᴹ ↑ᴹ Aᴹ
      π₁ᴹ⨟ᴹ↑ᴹ
        : tr Subᴹ,ᶜᴹFam [π₁ᴹ⨟ᴹ]ᴹ (π₁ᴹ (σᴹ ⨟ᴹ τᴹ) ↑ᴹ Aᴹ)
        ≡ (σᴹ ↑ᴹ ([ π₁ᴹ τᴹ ]ᴹ Aᴹ)) ⨟ᴹ (π₁ᴹ τᴹ ↑ᴹ Aᴹ)
      ∅ˢᴹ↑ᴹ
        : ∅ˢᴹ {Δᴹ = Δᴹ} ↑ᴹ Aᴹ ≡ ∅ˢᴹ ⁺ᴹ
      ,ˢᴹ↑ᴹ
        : (σᴹ ,ˢᴹ tᴹ) ↑ᴹ Aᴹ ≡ (σᴹ ,ˢᴹ tᴹ) ⁺ᴹ
      π₁ᴹidSᴹ↑ᴹ
        : π₁ᴹ {Aᴹ = Bᴹ} idSᴹ ↑ᴹ Aᴹ ≡ π₁ᴹ idSᴹ ⁺ᴹ
      π₁ᴹπ₁ᴹ↑ᴹ
        : π₁ᴹ (π₁ᴹ σᴹ) ↑ᴹ Aᴹ ≡ π₁ᴹ (π₁ᴹ σᴹ) ⁺ᴹ

      [_]tᴹ_
        : (σᴹ : Subᴹ Γᴹ Δᴹ σ)(tᴹ : Tmᴹ Δᴹ Aᴹ t)
        → Tmᴹ Γᴹ ([ σᴹ ]ᴹ Aᴹ) ([ σ ]t t)

      [idSᴹ]tᴹ
        : tr TmᴹFamₜ [idSᴹ] ([ idSᴹ ]tᴹ tᴹ) ≡ tᴹ
      [⨟ᴹ]tᴹ
        : tr TmᴹFamₜ [⨟ᴹ]ᴹ ([ σᴹ ⨟ᴹ τᴹ ]tᴹ tᴹ)
        ≡ [ σᴹ ]tᴹ [ τᴹ ]tᴹ tᴹ
      [π₁ᴹ,ˢᴹ]tᴹ
        : tr TmᴹFamₜ [π₁ᴹ,ˢᴹ]ᴹ ([ π₁ᴹ (σᴹ ,ˢᴹ tᴹ) ]tᴹ uᴹ)
        ≡ [ σᴹ ]tᴹ uᴹ
      [π₁ᴹ⨟ᴹ]tᴹ
        : tr TmᴹFamₜ [π₁ᴹ⨟ᴹ]ᴹ ([ π₁ᴹ (σᴹ ⨟ᴹ τᴹ) ]tᴹ tᴹ)
        ≡ [ σᴹ ]tᴹ ([ π₁ᴹ τᴹ ]tᴹ tᴹ)
      [∅ˢᴹ]tᴹ
        : [ ∅ˢᴹ {Δ} {Δᴹ} ]tᴹ tᴹ ≡ [ ∅ˢᴹ ]tmᴹ tᴹ
      [,ˢᴹ]tᴹ
        : [ σᴹ ,ˢᴹ tᴹ ]tᴹ uᴹ ≡ [ σᴹ ,ˢᴹ tᴹ ]tmᴹ uᴹ
      [π₁ᴹidSᴹ]tᴹ
        : [ π₁ᴹ {Γᴹ = Γᴹ ,ᶜᴹ Aᴹ} idSᴹ ]tᴹ tᴹ
        ≡ [ π₁ᴹ idSᴹ ]tmᴹ tᴹ
      [π₁ᴹπ₁ᴹ]tᴹ
        : [ π₁ᴹ (π₁ᴹ σᴹ) ]tᴹ tᴹ ≡ [ π₁ᴹ (π₁ᴹ σᴹ) ]tmᴹ tᴹ

      -- 
      _⨟ᴹidSᴹ
        : (σᴹ : Subᴹ Γᴹ Δᴹ σ)
        → tr SubᴹFam (σ ⨟idS) (σᴹ ⨟ᴹ idSᴹ) ≡ σᴹ
      idSᴹ⨟ᴹ_
        : (σᴹ : Subᴹ Γᴹ Δᴹ σ)
        → tr SubᴹFam (idS⨟ σ) (idSᴹ ⨟ᴹ σᴹ) ≡ σᴹ
      ⨟ᴹ-assoc
        : tr SubᴹFam ⨟-assoc (σᴹ ⨟ᴹ (τᴹ ⨟ᴹ γᴹ))
        ≡ (σᴹ ⨟ᴹ τᴹ) ⨟ᴹ γᴹ
      π₁ᴹ,ˢᴹ
        : tr (Subᴹ Γᴹ Δᴹ) π₁, (π₁ᴹ (σᴹ ,ˢᴹ tᴹ)) ≡ σᴹ
      ⨟ᴹ,ˢᴹ -- the transport equation seems too long
        : tr SubᴹFam ⨟, (σᴹ ⨟ᴹ (τᴹ ,ˢᴹ tᴹ))
        ≡ (σᴹ ⨟ᴹ τᴹ) ,ˢᴹ tr TmᴹFamₜ (sym $ [⨟ᴹ]ᴹ) ([ σᴹ ]tᴹ tᴹ)
      η∅ˢᴹ
        : tr SubᴹFam η∅ σᴹ ≡ ∅ˢᴹ
      η,ˢᴹ
        : tr SubᴹFam η, σᴹ ≡ π₁ᴹ σᴹ ,ˢᴹ π₂ᴹ σᴹ
      [idSᴹ]tmᴹ
        : tr₂ (Tmᴹ Γᴹ) [idSᴹ] [idS]tm ([ idSᴹ ]tmᴹ tᴹ)
        ≡ tᴹ
      [⨟ᴹ]tmᴹ
        : tr₂ (Tmᴹ Γᴹ) [⨟ᴹ]ᴹ [⨟]tm ([ σᴹ ⨟ᴹ τᴹ ]tmᴹ tᴹ)
        ≡ [ σᴹ ]tmᴹ ([ τᴹ ]tmᴹ tᴹ)
      π₂ᴹ,ˢᴹ
        : tr₂ (Tmᴹ Γᴹ) [π₁ᴹ,ˢᴹ]ᴹ π₂, (π₂ᴹ (σᴹ ,ˢᴹ tᴹ))
        ≡ tᴹ

  record Univ (C : CwF) : Set (ℓ ⊔ ℓ′) where
    open CwF C

    field
      Uᴹ
        : Tyᴹ Γᴹ U
      Elᴹ
        : Tmᴹ Γᴹ Uᴹ t
        → Tyᴹ Γᴹ (El t)
      []ᴹUᴹ
        : [ σᴹ ]ᴹ Uᴹ ≡ Uᴹ
      []ᴹElᴹ
        : (σᴹ : Subᴹ Γᴹ Δᴹ σ)(uᴹ : Tmᴹ Δᴹ Uᴹ u)
        → ([ σᴹ ]ᴹ (Elᴹ uᴹ)) ≡ Elᴹ (tr TmᴹFamₜ []ᴹUᴹ ([ σᴹ ]tᴹ uᴹ))

  record Π-type (C : CwF) : Set (ℓ ⊔ ℓ′) where
    open CwF C
    field 
      Πᴹ
        : (Aᴹ : Tyᴹ Γᴹ A)(Bᴹ : Tyᴹ (Γᴹ ,ᶜᴹ Aᴹ) B)
        → Tyᴹ Γᴹ (Π A B)
      ƛᴹ_
        : Tmᴹ (Γᴹ ,ᶜᴹ Aᴹ) Bᴹ t
        → Tmᴹ Γᴹ (Πᴹ Aᴹ Bᴹ) (ƛ t)
      appᴹ
        : Tmᴹ Γᴹ (Πᴹ Aᴹ Bᴹ) t
        → Tmᴹ (Γᴹ ,ᶜᴹ Aᴹ) Bᴹ (app t)
      []ᴹΠᴹ
        : [ σᴹ ]ᴹ (Πᴹ Aᴹ Bᴹ) ≡ Πᴹ ([ σᴹ ]ᴹ Aᴹ) ([ σᴹ ↑ᴹ Aᴹ ]ᴹ Bᴹ)
      []ƛᴹ
        : (σ : Sub Γ Δ) (σᴹ : Subᴹ Γᴹ Δᴹ σ)
        → tr₂ (Tmᴹ Γᴹ) []ᴹΠᴹ ([]ƛ σ _) ([ σᴹ ]tᴹ (ƛᴹ tᴹ))
        ≡ ƛᴹ ([ σᴹ ↑ᴹ Aᴹ ]tᴹ tᴹ)

  record Id-type (C : CwF) (U : Univ C) : Set (ℓ ⊔ ℓ′) where
    open CwF C
    open Univ U
    field
      Idᴹ
        : (aᴹ : Tmᴹ Γᴹ Uᴹ a)(tᴹ : Tmᴹ Γᴹ (Elᴹ aᴹ) t)(uᴹ : Tmᴹ Γᴹ (Elᴹ aᴹ) u)
        → Tyᴹ Γᴹ (Id a t u)
      []ᴹIdᴹ
        : [ σᴹ ]ᴹ (Idᴹ aᴹ tᴹ uᴹ)
        ≡ Idᴹ (tr TmᴹFamₜ []ᴹUᴹ ([ σᴹ ]tᴹ aᴹ))
            (tr TmᴹFamₜ ([]ᴹElᴹ σᴹ aᴹ) ([ σᴹ ]tᴹ tᴹ))
            (tr TmᴹFamₜ ([]ᴹElᴹ σᴹ aᴹ) ([ σᴹ ]tᴹ uᴹ))
      reflectᴹ
        : (Pp : Tmᴹ Γᴹ (Idᴹ aᴹ tᴹ uᴹ) p)
        → tr TmᴹFam (reflect p) tᴹ ≡ uᴹ

  record Method : Set (ℓ ⊔ ℓ′) where
    field
      𝒞    : CwF
      univ : Univ 𝒞
      piTy : Π-type 𝒞
      idTy : Id-type 𝒞 univ

    open CwF 𝒞        public
    open Univ univ    public
    open Π-type piTy  public
    open Id-type idTy public
