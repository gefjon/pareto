(uiop:define-package :pareto/test/package
  (:nicknames :pareto/test)
  (:use :fiveam :pareto/package :pareto/prelude)
  (:import-from :alexandria #:set-equal))
(in-package :pareto/test/package)

(def-suite pareto-tests)
(def-suite simple-games :in pareto-tests)

(defun rock-paper-scissors-play-integer (play)
  (ecase play
    (:rock 0)
    (:paper 1)
    (:scissors 2)))

(defmethod calculate-payoffs ((game (eql :rock-paper-scissors)) (deck-1 symbol) (deck-2 symbol))
  (aref
   #2a((0d0 -1d0 1d0)
       (1d0 0d0 -1d0)
       (-1d0 1d0 0d0))
   (rock-paper-scissors-play-integer deck-1)
   (rock-paper-scissors-play-integer deck-2)))

(defmethod generate-decks ((game (eql :rock-paper-scissors)) card-set &key count)
  (when card-set
    (warn "ignoring CARD-SET argument ~a for :ROCK-PAPER-SCISSORS"
          card-set))
  (let* ((choices #(:rock :paper :scissors)))
    (if count
        (iter (repeat count)
          (collect (aref choices (random (length choices)))
            result-type vector))
        choices)))

(def-test rock-paper-scissors-all-in-frontier (:suite simple-games)
  (multiple-value-bind (frontier payoffs) (compute-pareto-frontier :rock-paper-scissors nil)
    (is (= 3 (length frontier)))
    (is (set-equal '(:rock :paper :scissors) (coerce frontier 'list)
                   :test #'eq))
    (is (every #'zerop payoffs))))
