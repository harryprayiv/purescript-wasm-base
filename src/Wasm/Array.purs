-- | The **first-order** array primitives the higher-order array combinators are built on. 
-- | The `foreign import`s resolve to **intrinsics** on the wasm backend
-- | (`Intrinsics.qualifiedIntrinsic` — `Wasm.Array.*`), so they need no `.wat`; the
-- | accompanying `Wasm/Array.js` provides them for stock `purs` / `purs-backend-es`, so a
-- | `wasm-base`-using project also compiles and runs on the JS backends. On wasm the JS
-- | foreigns are ignored.
module Wasm.Array
  ( length
  , unsafeIndex
  , unsafeNew
  , unsafeSet
  ) where

-- | The element count. On wasm: the `ArrayLength` intrinsic (`array.len`).
foreign import length :: forall a. Array a -> Int

-- | The element at index `i`, **unchecked** (no bounds test — out of range traps). On wasm:
-- | the `ArrayIndex` intrinsic (`array.get`; the element is already an `eqref`, no box).
foreign import unsafeIndex :: forall a. Array a -> Int -> a

-- | Allocate a length-`n` array whose elements are **uninitialised** (null) until written —
-- | reading before `unsafeSet` traps. On wasm: the `ArrayNew` intrinsic (`array.new`).
foreign import unsafeNew :: forall a. Int -> Array a

-- | Write `v` at index `i`, **mutating the array in place**, and return that same array, so a
-- | builder loop threads it — keeping the write live (not dead-code-eliminated) and ordered by
-- | the data dependency, without needing an effect. Unchecked (out of range traps). On wasm:
-- | the `ArraySet` intrinsic (`array.set`, then yields the array).
foreign import unsafeSet :: forall a. Array a -> Int -> a -> Array a
