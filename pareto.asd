(defsystem "pareto"
  :version "0.0.1"
  :author "Phoebe Goldman <phoebe@goldman-tribe.org"
  :class :package-inferred-system
  :in-order-to ((test-op (test-op "pareto/test")))
  :depends-on ("pareto/package"))

(defsystem "pareto/test"
  :version "0.0.1"
  :author "Phoebe Goldman <phoebe@goldman-tribe.org"
  :class :package-inferred-fiveam-tester-system
  :defsystem-depends-on ((:version "fiveam-asdf" "3.0.1"))
  :depends-on ("pareto/test/package")
  :test-package :pareto/test/package
  :test-names (#:pareto-tests))
