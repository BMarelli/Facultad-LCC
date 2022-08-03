
module Records where

open import Relation.Binary.PropositionalEquality
open import Axiom.Extensionality.Propositional as Ext

-- postulamos extensionalidad
postulate ext : ∀{a b} → Ext.Extensionality a b

{- Veremos, el uso de records para definir estructuras algebraicas -}


-- MONOIDES

{- Notar el uso de de Set₁ en lugar de Set ya que tenemos que
 situarnos en el nivel siguiente a Set₀ = Set, para hablar de cosas en
 Set (como carrier).g₁ : Hom (ArrowObj.from A) (ArrowObj.from A')
   g₂ : Hom (ArrowObj.to B) (ArrowObj.to B')
   prop :  f' ∙ g₁ ≡ g₂ ∙ f

Los subindices son ₀ = \_0 y ₁ = \_1
 -}

record Monoid : Set₁  where
  infixr 7 _∙_
  -- constructor monoid
  field  Carrier : Set
         _∙_     : Carrier → Carrier → Carrier  {- ∙ = \. -}
         ε       : Carrier   {- ε = \epsilon -}
         lid     : {x : Carrier} → ε ∙ x ≡ x
         rid     : {x : Carrier} → x ∙ ε ≡ x
         assoc   : {x y z : Carrier} → (x ∙ y) ∙ z ≡ x ∙ (y ∙ z) 

{- ¿Qué sucede si queremos usar un Carrier en Set₁? ¿o en Set₂? -}

{- Al escribir las ecuaciones estamos tomando una decisión sobre la noción de igualdad 
 En esta definición elegimos la igualdad proposicional
-}

open import Data.Nat
open import Data.Nat.Properties using (+-identityʳ ; +-assoc ; *-distribʳ-+)

-- Monoide de Naturales y suma

module NatMonoid where


  NatMonoid : Monoid
  NatMonoid = record
    { Carrier = ℕ 
    ; _∙_ = _+_ 
    ; ε = 0 
    ; lid = refl 
    ; rid = λ {x} → +-identityʳ x ; 
    assoc = λ {x} {y} {z} → +-assoc x y z }

open NatMonoid


--------------------------------------------------
{- Ejercicio: Probar que las listas son un monoide -}

open ≡-Reasoning
open import Data.List

module ListMonoid where
  open import Data.List.Properties using (++-identityʳ; ++-assoc)

  ListMonoid : Set -> Monoid
  ListMonoid X = record {
                  Carrier = List X ;
                  _∙_ = _++_ ;
                  ε = [] ;
                  lid = refl ;
                  rid = λ {x} → ++-identityʳ x ;
                  assoc = λ {x} {y} {z} → ++-assoc x y z
                 }

--------------------------------------------------

{- Ejercicio: Probar que para todo monoide M, N, el producto
   cartesiano de los respectivos soportes (Carrier M × Carrier N)
   es  el soporte de un monoide

 Ayuda : puede ser útil cong₂
-}

open import Data.Product renaming (proj₁ to fst; proj₂ to snd)

module ProdMonoid where
  _×M_ : Monoid -> Monoid -> Monoid
  _×M_ M N = record {
                Carrier = CM × CN ;
                _∙_ = λ { (m₁ , m₂) (n₁ , n₂) → m₁ ∙₁ n₁ , m₂ ∙₂ n₂ } ;
                ε = ε₁ , ε₂ ;
                lid = cong₂ _,_ Mlid Nlid ;
                rid = cong₂ _,_ Mrid Nrid ;
                assoc = cong₂ _,_ Massoc Nassoc
             }
    where
      open Monoid M renaming (Carrier to CM ; ε to ε₁ ;  _∙_ to _∙₁_ ; lid to Mlid ; rid to Mrid ; assoc to Massoc)
      open Monoid N renaming (Carrier to CN ; ε to ε₂ ;  _∙_ to _∙₂_ ; lid to Nlid ; rid to Nrid ; assoc to Nassoc)

--------------------------------------------------
open import Function

-- Monoide de endofunciones
EndoMonoid : Set → Monoid
EndoMonoid X = record
                 { Carrier = X → X
                 ; _∙_ = _∘′_
                 ; ε = id
                 ; lid = refl
                 ; rid = refl
                 ; assoc = refl }


module Cayley where

  open Monoid using (Carrier)

  Cayley : Monoid → Monoid
  Cayley M = EndoMonoid (Carrier M) 

  rep : (M : Monoid) → Carrier M → Carrier (Cayley M)
  rep M x = λ y → x ∙ y
           where open Monoid M

  abs : (M : Monoid) → Carrier (Cayley M) → Carrier M
  abs M f = f ε
           where open Monoid M

  lemma : (M : Monoid) → {x : Carrier M} →
          abs M (rep M x) ≡ x
  lemma M = rid
           where open Monoid M

module Monoid-Homomorphism where
 open Monoid

-- Homomorfismos de monoides
 record Is-Monoid-Homo (M N : Monoid)(morph : Carrier M → Carrier N) : Set₁ where
   open Monoid M renaming (ε to ε₁ ;  _∙_ to _∙₁_)
   open Monoid N renaming (ε to ε₂ ;  _∙_ to _∙₂_)
   field
    preserves-unit : morph ε₁ ≡ ε₂
    preserves-mult : ∀{x y} → morph (x ∙₁ y) ≡ morph x ∙₂ morph y 

open Monoid-Homomorphism
open Cayley

rep-is-monoid-homo : {M : Monoid} → Is-Monoid-Homo M (Cayley M) (rep M)
rep-is-monoid-homo {M} = record {
                         preserves-unit = ext (λ x → lid)
                       ; preserves-mult = ext (λ x → assoc) }
                  where open Monoid M

--------------------------------------------------
{- Ejercicio: Probar que length es un homorfismo de monoides -}

open ListMonoid

length-proof : {X : Set} -> (xs : List X) -> (ys : List X) -> length (xs ++ ys) ≡ length xs + length ys
length-proof [] ys = refl
length-proof (x ∷ xs) ys = cong suc (length-proof xs ys)

length-is-monoid-homo : {X : Set} -> Is-Monoid-Homo (ListMonoid X) NatMonoid length
length-is-monoid-homo {X} = record {
                              preserves-unit = refl ;
                              preserves-mult = λ {x} {y} → length-proof x y }

--------------------------------------------------
{- Ejercicio: Probar que multiplicar por una constante es un es un homorfismo de NatMonoid -}

mult-const-is-monoid-homo : {k : ℕ} -> Is-Monoid-Homo NatMonoid NatMonoid (_* k)
mult-const-is-monoid-homo {k} = record { 
                                  preserves-unit = refl ;
                                  preserves-mult = λ {x} {y} → *-distribʳ-+ k x y }

--------------------------------------------------
module Foldr (M : Monoid) where

  open Monoid M

  {- Ejercicio : Definir foldr y probar que (foldr _∙_ ε) es un homorfismo de monoides -}

  foldr-proof : (xs : List Carrier) → (ys : List Carrier) → foldr _∙_ ε (xs ++ ys) ≡ foldr _∙_ ε xs ∙ foldr _∙_ ε ys
  foldr-proof [] ys = sym lid
  foldr-proof (x ∷ xs) ys =
    begin
      x ∙ (foldr _∙_ ε (xs ++ ys))
    ≡⟨ (cong (x ∙_) (foldr-proof xs ys)) ⟩
      (x ∙ (foldr _∙_ ε xs ∙ foldr _∙_ ε ys))
    ≡⟨ sym assoc ⟩
      (x ∙ foldr _∙_ ε xs) ∙ (foldr _∙_ ε ys)
    ∎

  foldr-is-monoid-homo : Is-Monoid-Homo (ListMonoid Carrier) M (foldr _∙_ ε)
  foldr-is-monoid-homo = record {
                          preserves-unit = refl ;
                          preserves-mult = λ {xs} {ys} → foldr-proof xs ys }

--------------------------------------------------

{- Isomorfismos entre conjuntos -}

record Iso (A : Set)(B : Set) : Set where
  field fun : A → B
        inv : B → A
        law1 : ∀ b → fun (inv b) ≡ b
        law2 : ∀ a → inv (fun a) ≡ a

open Iso

-----------------------------

{- Ejercicio : introducir un tipo de datos (record) ⊤ con un único habitante y
probar que  ℕ es isomorfo a List ⊤ -}

module NatIsoList where
  data ⊤ : Set where
    tt : ⊤

  fun-proof : ℕ -> List ⊤
  fun-proof zero = []
  fun-proof (suc n) = tt ∷ fun-proof n

  inv-proof : List ⊤ -> ℕ
  inv-proof xs = length xs

  law1-proof : (xs : List ⊤) -> fun-proof (inv-proof xs) ≡ xs
  law1-proof [] = refl
  law1-proof (tt ∷ xs) = cong (tt ∷_) (law1-proof xs)

  law2-proof : (n : ℕ) -> inv-proof (fun-proof n) ≡ n
  law2-proof zero = refl
  law2-proof (suc n) = cong suc (law2-proof n)
  

  ℕ-is-List-iso : Iso ℕ  (List ⊤)
  ℕ-is-List-iso = record { 
                    fun = fun-proof ;
                    inv = inv-proof ;
                    law1 = law1-proof ;
                    law2 = law2-proof }

{- Ejercicio: introducir un constructor de tipos Maybe (o usar Data.Maybe) y probar que
Maybe ℕ es isomorfo a ℕ -}

module MaybeIsoNat where
  data Maybe {a} (A : Set a) : Set a where
    just : A → Maybe A
    nothing : Maybe A

  fun-proof : Maybe ℕ -> ℕ
  fun-proof nothing = zero
  fun-proof (just n) = suc n

  inv-proof : ℕ -> Maybe ℕ
  inv-proof zero = nothing
  inv-proof (suc n) = just n

  law1-proof : (n : ℕ) -> fun-proof (inv-proof n) ≡ n
  law1-proof zero = refl
  law1-proof (suc n) = refl

  law2-proof : (n : Maybe ℕ) -> inv-proof (fun-proof n) ≡ n
  law2-proof nothing = refl
  law2-proof (just x) = refl
  
  Maybeℕ-is-ℕ-iso : Iso (Maybe ℕ) ℕ
  Maybeℕ-is-ℕ-iso = record {
                      fun = fun-proof ;
                      inv = inv-proof ;
                      law1 = law1-proof ;
                      law2 = law2-proof }
    

{- Ejercicio: introducir un constructor de tipos _×_ para productos
cartesianos (o usar el de Data.Product) y probar que (A → B × C) es
isomorfo a (A → B) × (A → C) para todos A, B, y C, habitantes de Set -}
module ProdIsoProd' where
  open import Data.Product
  
  fun-proof : {A B C : Set} -> (A -> B × C) -> ((A -> B) × (A -> C))
  fun-proof f = (λ x → proj₁ (f x)) , λ x → proj₂ (f x)

  inv-proof : {A B C : Set} -> ((A -> B) × (A -> C)) -> (A -> B × C)
  inv-proof (fst , snd) = λ x → (fst x) , (snd x)

  prod-is-prod'-iso : {A B C : Set} -> Iso (A -> B × C) ((A -> B) × (A -> C))
  prod-is-prod'-iso = record {
                        fun = fun-proof ;
                        inv = inv-proof ;
                        law1 = λ b → refl ;
                        law2 = λ a → refl }


{- Ejercicio: construir isomorfismos entre Vec A n × Vec B n y
Vec (A × B) n para todos A, B habitantes de Set y n natural -}

module VecIsoVec' where
  open import Data.Vec

  fun-proof : {n : ℕ} -> {A B : Set} -> ((Vec A n) × (Vec B n)) -> Vec (A × B) n
  fun-proof ([] , []) = []
  fun-proof (x ∷ xs , y ∷ ys) = (x , y) ∷ (fun-proof (xs , ys))

  inv-proof : {n : ℕ} -> {A B : Set} -> Vec (A × B) n -> ((Vec A n) × (Vec B n))
  inv-proof [] = [] , []
  inv-proof (v ∷ vs) with inv-proof vs
  ...| as , bs = ((fst v) ∷ as) , ((snd v) ∷ bs)

  law1-proof : {n : ℕ} -> {A B : Set} -> (vs : Vec (A × B) n) -> fun-proof (inv-proof vs) ≡ vs
  law1-proof [] = refl
  law1-proof (v ∷ vs) = cong (λ x → v ∷ x) (law1-proof vs)

  law2-proof : {n : ℕ} -> {A B : Set} -> (vs : (Vec A n) × (Vec B n)) -> inv-proof (fun-proof vs) ≡ vs
  law2-proof ([] , []) = refl
  law2-proof (x ∷ xs , y ∷ ys) = cong (λ p → (x ∷ fst p) , (y ∷ snd p)) (law2-proof (xs , ys))
  
  vec-is-vec'-iso : {n : ℕ } -> {A B : Set} -> Iso ((Vec A n) × (Vec B n)) (Vec (A × B) n)
  vec-is-vec'-iso = record {
                      fun = fun-proof ;
                      inv = inv-proof ;
                      law1 = law1-proof ;
                      law2 = law2-proof }

--------------------------------------------------
{- Ejercicio Extra
 Mostrar que en el caso de la categoría Sets, isomorfismo corresponde a biyección de funciones

Ayuda : puede ser útil usar cong-app
-}

Biyectiva : {X Y : Set}(f : X → Y) → Set
Biyectiva {X} {Y} f = (y : Y) → Σ X (λ x → (f x ≡ y) × (∀ x' → f x' ≡ y → x ≡ x')) 
    