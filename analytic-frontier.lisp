(uiop:define-package :pareto/analytic-frontier
  (:use :pareto/prelude :pareto/game-interface)
  (:export #:compute-pareto-frontier))
(in-package :pareto/analytic-frontier)

(typedec #'payoff-matrix (func (t vector) payoff-matrix))
(defun payoff-matrix (game-rules decks)
  (let* ((num-decks (length decks))
         (payoffs (make-array (list num-decks num-decks)
                              :element-type 'double-float
                              :initial-element 0d0)))
    (iter (for deck-1 in-vector decks with-index i)
      (iter (for deck-2 in-vector decks with-index j)
        (setf (aref payoffs i j)
              (calculate-payoffs game-rules deck-1 deck-2))))
    payoffs))

(typedec #'sum-payoff-matrix (func (payoff-matrix) (vector payoff)))
(defun sum-payoff-matrix (payoff-matrix)
  (iter (for deck-1 below (array-dimension payoff-matrix 0))
    (collect (iter (for deck-2 below (array-dimension payoff-matrix 1))
               (sum (aref payoff-matrix deck-1 deck-2)))
      result-type (vector payoff))))

(typedec #'vector-max (func ((vector payoff)) payoff))
(defun vector-max (vec)
  (iter (for elt in-vector vec)
    (maximize elt)))

(typedec #'filter-within-threshold
         (func (vector (vector payoff) payoff payoff)
               (values vector (vector payoff))))
(defun filter-within-threshold (decks payoffs target threshold)
  (iter (for deck in-vector decks)
    (for payoff in-vector payoffs)
    (when (<= (abs (- target payoff)) threshold)
      (collect deck result-type vector into optimal-decks)
      (collect payoff result-type (vector payoff) into optimal-payoffs))
    (finally (return (values optimal-decks optimal-payoffs)))))

(defun compute-pareto-frontier (game-rules card-set &key (threshold 0d0))
  (let* ((decks (generate-decks game-rules card-set))
         (payoff-matrix (payoff-matrix game-rules decks))
         (payoff-sums (sum-payoff-matrix payoff-matrix))
         (max (vector-max payoff-sums)))
    (filter-within-threshold decks payoff-sums max threshold)))
