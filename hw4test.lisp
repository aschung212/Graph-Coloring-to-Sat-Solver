;;;;=============== node2var ============================
; node2var (n c k)
(format t "(node2var 1 0 0) = ~S~%" (node2var 1 0 0))
(format t "(node2var 1 0 1) = ~S~%" (node2var 1 0 1))
(format t "(node2var 1 1 1) = ~S~%" (node2var 1 1 1))
(format t "(node2var 1 2 3) = ~S~%" (node2var 1 2 3))
(format t "(node2var 5 2 5) = ~S~%" (node2var 5 2 5))
(format t "*INVALID INPUT* (node2var 1 1 0) = ~S~%" (node2var 1 1 0))
(format t "==================================~%~%")

;;;;=============== at-least-one-color ==================
; at-least-one-color (n c k)
(format t "(at-least-one-color 1 1 3) = ~S~%" (at-least-one-color 1 1 3))
(format t "(at-least-one-color 1 3 3) = ~S~%" (at-least-one-color 1 3 3))
(format t "(at-least-one-color 2 2 4) = ~S~%" (at-least-one-color 2 2 4))
(format t "*INVALID INPUT* (at-least-one-color 1 2 1) = ~S~%" (at-least-one-color 1 2 1))
(format t "==================================~%~%")

;;;;================ pairs ================================
; pairs (front rest)
(format t "(pairs 1 '(2 3)) = ~S~%" (pairs 1 '(2 3)))
(format t "(pairs 1 '(2 3 4 5)) = ~S~%" (pairs 1 '(2 3 4 5)))
(format t "(pairs 1 '()) = ~S~%" (pairs 1 '()))
(format t "==================================~%~%")

;;;;================ all-pairs ============================
; all-pairs (s)
(format t "(all-pairs '(1 2) = ~S~%" (all-pairs '(1 2)))
(format t "(all-pairs '(1 2 3) = ~S~%" (all-pairs '(1 2 3)))
(format t "(all-pairs '(1 2 3 4) = ~S~%" (all-pairs '(1 2 3 4)))
(format t "(all-pairs '(1) = ~S~%" (all-pairs '(1)))
(format t "==================================~%~%")

;;;;================ negate =================================
; negate (s)
(format t "(negate '(1) = ~S~%" (negate '(1)))
(format t "(negate '(1 2) = ~S~%" (negate '(1 2)))
(format t "(negate '() = ~S~%" (negate '()))
(format t "==================================~%~%")

;;;;================ at-most-one-color ======================
; at-most-one-color (n c k)
(format t "(at-most-one-color 1 0 1) = ~S~%" (at-most-one-color 1 0 1))
(format t "(at-most-one-color 1 1 3) = ~S~%" (at-most-one-color 1 1 3))
(format t "(at-most-one-color 2 1 3) = ~S~%" (at-most-one-color 2 1 3))
(format t "(at-most-one-color 2 1 4) = ~S~%" (at-most-one-color 2 1 4))
(format t "==================================~%~%")

;;;;================ generate-node-clauses ====================
; generate-node-clauses (n k)
(format t "(generate-node-clauses 1 1) = ~S~%" (generate-node-clauses 1 1))
(format t "(generate-node-clauses 1 2) = ~S~%" (generate-node-clauses 1 2))
(format t "(generate-node-clauses 1 3) = ~S~%" (generate-node-clauses 1 3))
(format t "(generate-node-clauses 2 2) = ~S~%" (generate-node-clauses 2 2))
(format t "(generate-node-clauses 1 4) = ~S~%" (generate-node-clauses 1 4))
(format t "==================================~%~%")


;;;;================ generate-edge-clauses =====================
; generate-edge-clauses (e k)
(format t "(generate-edge-clauses '(1 2) 1) = ~S~%" (generate-edge-clauses '(1 2) 1))
(format t "(generate-edge-clauses '(1 2) 2) = ~S~%" (generate-edge-clauses '(1 2) 2))


(format t "~%")