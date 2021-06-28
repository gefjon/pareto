(uiop:define-package :pareto/prelude
  (:use :cl :iterate)
  (:import-from :gefjon-utils
                #:define-class
                #:typedec #:func #:void)
  (:reexport :cl :gefjon-utils :iterate)
  (:export #:assert-type #:payoff #:payoff-matrix))
(in-package :pareto/prelude)

(defun assert-type (datum expected-type)
  (if (typep datum expected-type)
      datum
      (error 'type-error
             :datum datum
             :expected-type expected-type)))

(deftype payoff () 'double-float)

(deftype payoff-matrix () '(array double-float (* *)))
