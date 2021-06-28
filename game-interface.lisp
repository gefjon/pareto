(uiop:define-package :pareto/game-interface
  (:use :pareto/prelude)
  (:export #:calculate-payoffs #:generate-decks))
(in-package :pareto/game-interface)

(defgeneric calculate-payoffs (game-rules deck-1 deck-2)
  (:method :around (game-rules deck-1 deck-2)
    (assert-type (call-next-method) 'double-float)))

(defgeneric generate-decks (game-rules card-set &key count &allow-other-keys)
  (:method :around (game-rules card-set &key &allow-other-keys)
    (assert-type (call-next-method) 'vector)))
