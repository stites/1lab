open import 1Lab.HLevel.Universe
open import 1Lab.Resizing
open import 1Lab.Type

module 1Lab.Underlying where

record Underlying {ℓ} (T : Type ℓ) : Typeω where
  field
    ℓ-underlying : Level
    ⌞_⌟          : T → Type ℓ-underlying

open Underlying ⦃ ... ⦄ using (⌞_⌟) public

open Underlying using (ℓ-underlying)

instance
  Underlying-Type : ∀ {ℓ} → Underlying (Type ℓ)
  Underlying-Type {ℓ} .ℓ-underlying = ℓ
  Underlying-Type .⌞_⌟ x = x

  Underlying-n-Type : ∀ {ℓ n} → Underlying (n-Type ℓ n)
  Underlying-n-Type {ℓ} .ℓ-underlying = ℓ
  Underlying-n-Type .⌞_⌟ x = ∣ x ∣

  Underlying-prop : Underlying Ω
  Underlying-prop .ℓ-underlying = lzero
  Underlying-prop .⌞_⌟ x = ∣ x ∣

  Underlying-Σ
    : ∀ {ℓ ℓ′} {A : Type ℓ} {B : A → Type ℓ′}
    → ⦃ ua : Underlying A ⦄
    → Underlying (Σ A B)
  Underlying-Σ ⦃ ua ⦄ .ℓ-underlying = ua .Underlying.ℓ-underlying
  Underlying-Σ .⌞_⌟ x               = ⌞ x .fst ⌟

  -- Workaround for Agda bug https://github.com/agda/agda/issues/6588 —
  -- the principal (instance) argument is reified as visible, so we can
  -- drop it using a display form.
  {-# DISPLAY Underlying.⌞_⌟ f x = ⌞ x ⌟ #-}
