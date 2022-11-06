open import Library
open import Categories
open import Categories.Sets
open import Categories.Iso {b = lzero} Sets
open import Naturals
open import Functors


{-
  Dada la categoria C localmente chica. Para cada objeto X ∈ Obj C y
  un funtor F : C Op -> Sets, hay un isomorfismo
          Hom(yX, F) ≅ FX
  Donde:
    - yX es el funtor de yoneda

  -------------------------------------------------------------------------
  | C es una categoria es localmente chica si ∀ X,Y ∈ Obj C, Hom(X, Y) es |
  | un conjunto.                                                          |
  -------------------------------------------------------------------------

  Para poder demostrar esto vamos a realizar 3 pasos:
    (1) Definir un morfismo η-map : Hom(yX, F) -> FX
    (2) Definir un morfismo ρ : FX -> Hom(yX, F)
       Notemos que ρ toma un a ∈ FX nos devuelve una transformacion lineal
       (demostrar naturalidad)
    (3) Demostrar que los morfismos en (1) y (2) son mutuamente inversos
-}

module yoneda.Yoneda {C : Cat {lzero} {lzero}} where -- Categoria localmente chica

open Cat C

{-
  yoneda : C Op -> Sets
  Sean X,Y,Z ∈ Obj C y f ∈ Hom (Y, Z)
    yoneda{X}(Y) = Hom(Y, X)
    yoneda{X}(f) : yoneda{X}(Z) -> yoneda{X}(Y)
                 : Hom(Z, X) -> Hom(Y, X)
    yoneda{X}(f) = λ g : Hom(Z, X) → g ∙ f
-}

yoneda : {X : Obj} -> Fun (C Op) Sets
yoneda {X} = functor
              (λ Y → Hom Y X)
              (λ f g → g ∙ f)
              (ext (λ _ → idr))
              (ext (λ _ → sym ass))

{-
  (1)
  Comenzamos definiendo el morfismo η-map:
    η-map : Hom(yX, F) -> FX
  Dado un δ : yX -> F
    η-map(δ) = δₓ(idₓ)

  Notemos que δₓ : yX(X) -> FX
                 : Hom(X, X) -> FX
  Entonces δₓ(idₓ) ∈ FX
-}
η-map : {X : Obj} {F : Fun (C Op) Sets} -> Cat.Hom Sets (NatT yoneda F) (Fun.OMap F X)
η-map {X} δ = let open NatT δ
              in cmp X iden

{-
  (2)
  Ahora para el otro lado, definamos ρ : FX -> Hom(yX, F)
  Notemos que dado cualquier a ∈ FX, definimos la transformacion natural:
      ρₐ : yX -> F
  Dado un X' : Obj
      ρₐX' : yX(X') -> FX'
      ρₐX' : Hom(X', X) -> FX'
      ρₐX'(h) = F(h) a
  
  A nosotros nos va a quedar ρ un morfismo que toma a ∈ FX y nos devuelve la transformacion natural.
  Notemos que dado a ∈ FX, X' ∈ Obj C,
    (NatT.cmp (ρ a) ) X' : Hom(X', X) -> FX'

  Para demostrar la condición de naturalidad hay que considerar el siguiente diagrama:
  Dado f : Hom(X', Y)

  yX(X') ------ yX(f) -----> yX(Y)     Hom(X', X) ------ yX(f) -----> Hom(Y, X)
    |                         |         |                               |
    |                         |         |                               |
   ρₐ X'                      ρₐ Y      ρₐ X'                            ρₐ Y
    |                         |         |                               |
    |                         |         |                               |
    V                         V         V                               V
  FX'    ------ F(f)  -----> FY        FX'  ------------ F(f)  ----->  FY

  Dado h ∈ yX(X'), queremos demostrar que:
    ρₐ Y ∙ yX(f)(h) ≅ F(f) ∙ ρₐ X' h
  Sabemos por definicion que:
  (∙) ρₐ Y (h) = F(h) a
  (∙) yX(f)(h) = h ∙ f
  Luego nos queda:
    ρₐ Y ∙ yX(f)(h) ≅ F(h ∙ f) a
-}

ρ : {X : Obj} {F : Fun (C Op) Sets} -> Cat.Hom Sets (Fun.OMap F X) (NatT yoneda F)
ρ {F = F} a = let open Fun F
              in natural
                 (λ X' h → (HMap h) a) -- (X' : Obj) → Hom X' X → OMap X
                 -- {X' Y : Obj} {f : Hom Y X'} →
                 -- (λ h → HMap f (HMap h a)) ≅ (λ h → HMap (h ∙ f) a)
                 (λ {X Y} {f} → ext (λ h → sym (proof
                                                  HMap (h ∙ f) a
                                                ≅⟨ cong (λ g → g a) fcomp ⟩
                                                  HMap f (HMap h a)
                                                ∎)))

{-
  (3)
  Ahora demostremos que η-map y ρ son mutuamente inversas:

  Primero demostremos que dado X,X' ∈ Obj C y δ : yX -> F,
    ρ (η-map δ) ≅ δ
  Si instanciamos en X' nos queda:
    ρ (η-map δ) X' ≅ δ X'
  Notemos que:
    (a) ρ (η-map δ) X' : Hom(X', X) -> FX'
    (b) δ X' : Hom(X', X) -> FX'

  -------------------------------------------------------------------
  |  Como (a) (b) son transformaciones naturales mas adelante vamos |
  |  a utilizar NatTEq (queremos ver que son iguales)               |
  -------------------------------------------------------------------

  Tenemos una transformacion natural: δ : yX -> F
  yX(X) ----- yX(h) ----> yX(X')
    |                      |
    |                      |
   δ X                    δ X'
    |                      |
    |                      |
    V                      V       
  FX    -----  F h  ----> FX'
-}

ρ-inv-η-map : {X X' : Obj} {F : Fun (C Op) Sets} {δ : NatT (yoneda {X}) F} ->
               (NatT.cmp (ρ {X} {F} (η-map {X} {F} δ))) X' ≅ NatT.cmp δ X'
ρ-inv-η-map {X} {X'} {F} {δ} =
    let open NatT (ρ {X} {F} (η-map {X} {F} δ)) renaming (cmp to ρ'; nat to ρ-nat)
        open NatT (δ) renaming (cmp to δ'; nat to δ-nat)
        open Fun (yoneda {X}) renaming (OMap to yX-OMap; HMap to yX-HMap; fid to yX-fid; fcomp to yX-fcomp)
        open Fun F renaming (OMap to F-OMap; HMap to F-HMap; fid to F-fid; fcomp to F-fcomp)
    -- Dado h : Hom X' X queremos probar ρ' X' h ≅ δ' X' h
    in ext (λ h → proof
                    ρ' X' h
                  ≅⟨ refl ⟩
                    (F-HMap h) (δ' X iden)
                  -- (λ x → F-HMap h (δ' X x)) ≅ (λ x → δ' X' (x ∙ h))
                  ≅⟨ cong (λ x → x iden) (δ-nat {X} {X'} {h}) ⟩
                    (δ' X') ((yX-HMap h) iden)
                  ≅⟨ cong (δ' X') idl ⟩
                    δ' X' h
                  ∎)
{-
  Ahora demostremos que dado X ∈ Obj C y a ∈ FX,
    η-map (ρ a) ≅ a
-}

η-map-inv-ρ : {X : Obj} {F : Fun (C Op) Sets} {a : Fun.OMap F X} ->
               η-map (ρ {X} {F} a) ≅ a
η-map-inv-ρ {X} {F} {a} =
    let open Fun F
        open NatT (ρ {X} {F} a)
    in proof
        η-map (ρ {X} {F} a)
       ≅⟨ refl ⟩
        cmp X iden
       ≅⟨ refl ⟩
        (HMap iden) a
       ≅⟨ cong (λ x → x a) fid ⟩
        a
       ∎

lemma-yoneda : {X : Obj} {F : Fun (C Op) Sets} -> Iso (η-map {X} {F})
lemma-yoneda {X} {F} = iso
                        ρ
                        (ext (λ a → η-map-inv-ρ {X} {F} {a}))
                        (ext (λ δ → NatTEq (ext (λ X' → ρ-inv-η-map {X} {X'} {F} {δ}))))
 