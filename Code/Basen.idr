module Basen

import Data.Fin

--Fin to Nat
tonatFin: (n: Nat) -> Fin(n) -> Nat
tonatFin (S k) FZ = Z
tonatFin (S k) (FS x) = S (tonatFin k x)

--List Fin to Nat
tonat: (n: Nat) -> List (Fin(n)) -> Nat
tonat n [] = Z
tonat n (x :: xs) = (tonatFin n x)*(power n (length xs)) + (tonat n xs)


--Euclid's div
Eucl: (a: Nat) -> (b: Nat) -> (Nat, Nat)
Eucl Z b = (0,0)
Eucl (S k) b = case (lte (S (S k)) b) of
                    False => (S(fst(Eucl (minus (S k) b) b)), snd(Eucl (minus (S k) b) b))
                    True => (0, S k)

--Nat to Fin (modular values)
tofinNat: (a: Nat) -> (n: Nat) -> Fin n
tofinNat Z (S j) = FZ
tofinNat (S k) (S j) = case lte (S k) (S j) of
                True => FS (tofinNat k j)
                False =>  (tofinNat (snd(Eucl (S k) (S j))) (S j))

--left strips FZ from lists
strp: List (Fin n) -> List (Fin n)
strp [] = []
strp (x :: xs) = case x of
                      FZ => strp(xs)
                      (FS y) => x::xs

-- Nat to List Fin n (base n representation)
tofin: Nat -> (n: Nat) -> List (Fin n)
tofin Z (S j) = [FZ]
tofin (S k) (S j) = strp(reverse(rem :: reverse(tofin q (S j)))) where
                    rem = tofinNat (snd(Eucl (S k) (S j))) (S j)
                    q = fst(Eucl (S k) (S j))

--adding two Fin n's
addfin: (n: Nat) -> Fin (S n) -> Fin (S n) -> Fin (S n) -> (Fin (S n), Fin (S n))
addfin n x y z = case (tofin ((tonatFin (S n) x)+ (tonatFin (S n) y) + (tonatFin (S n) z)) (S n)) of
                    [l] => (FZ, l)
                    [k, l] => (k,l)

--adding two reversed lists as specified
addfinl: (n: Nat) -> List (Fin (S n)) -> List (Fin (S n)) -> List (Fin (S n))
addfinl n [] ys = strp(ys)
addfinl n (x :: xs) [] = strp(x::xs)
addfinl n (x :: xs) (y :: ys) = (snd(addfin n FZ x y)::(addfinl n (addfinl n [fst(addfin n FZ x y)] xs) ys))

--adding two lists
addfinlist: (n: Nat) -> List (Fin (S n)) -> List (Fin (S n)) -> List (Fin (S n))
addfinlist n xs ys = reverse(addfinl n (reverse xs) (reverse ys))

--embedding Fin n in Fin S n vertically
embn: (n: Nat) -> Fin n -> Fin (S n)
embn (S k) FZ = FZ
embn (S k) (FS x) = FS (embn k x)

--Unused mulfinNat - multiplies two Fin n's
mulfinNat: (n: Nat) -> Fin (n) -> Fin (n) -> (Fin (n), Fin (n))
mulfinNat (S n) x y =  case tofin ((tonatFin (S n) x)*(tonatFin (S n) y)) (S n) of
                    [l] => (FZ, l)
                    [k,l] => (k,l)

--multiply two reversed lists in Fin S n
mulfinl: (n: Nat) -> List (Fin (S n)) -> List (Fin (S n)) -> List (Fin (S n))
mulfinl n xs [] = []
mulfinl n xs (FZ :: ys) = FZ :: (mulfinl n xs ys)
mulfinl n xs ((FS x) :: ys) = addfinl n (mulfinl n xs ((embn n x)::ys)) xs

--multpily two lists
mulfinList: (n: Nat) -> List (Fin (S n)) -> List (Fin (S n)) -> List (Fin (S n))
mulfinList n xs ys = reverse(mulfinl n (reverse xs) (reverse ys))
