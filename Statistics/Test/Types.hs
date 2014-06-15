{-# LANGUAGE DeriveFunctor, DeriveDataTypeable #-}
module Statistics.Test.Types (
    Test(..)
  , isSignificant
  , TestResult(..)
  , significant
  , TestType(..)
  ) where

import Data.Typeable (Typeable)
import Statistics.Types (CL)

-- | Result of hypothesis testing
data TestResult = Significant    -- ^ Null hypothesis should be rejected
                | NotSignificant -- ^ Data is compatible with hypothesis
                  deriving (Eq,Ord,Show,Typeable)

-- | Result of statistical test. It contains test p-value (probability of encountering
data Test a = Test
  { testSignificance :: CL Double
  , testExtraData    :: a
  }
  deriving (Eq,Ord,Show,Typeable,Functor)

-- | Check whether test is significant for given p-value.
isSignificant :: CL Double -> Test a -> TestResult
isSignificant cl t
  -- FIXME: check what Ord instance have correct meaning
  = significant $ cl <= testSignificance t

-- | Test type. Exact meaning depends on a specific test. But
-- generally it's tested whether some statistics is too big (small)
-- for 'OneTailed' or whether it too big or too small for 'TwoTailed'
data TestType = OneTailed
              | TwoTailed
              deriving (Eq,Ord,Show,Typeable)

-- | Significant if parameter is 'True', not significant otherwiser
significant :: Bool -> TestResult
significant True  = Significant
significant False = NotSignificant
{-# INLINE significant #-}
