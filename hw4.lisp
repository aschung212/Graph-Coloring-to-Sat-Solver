; Aaron Chung
; 804288857
; CS161 Winter 2017: 
; hw4: Graph coloring to SAT conversion


;;;;;;;;;;;;;;;;;;;;;;
; General util.
;;;;;;;;;;;;;;;;;;;;;;


(defun reload()
  (load "hw4.lisp")
  );end defun

(defun runtest()
  (load "hw4test.lisp")
)


;;;========================================================================================================================

; returns the index of the variable
; that corresponds to the fact that 
; "node n gets color c" (when there are k possible colors).
;
(defun node2var (n c k)
  ;(n-1) * k + c
  (+ (* (- n 1) k) c)
)

;;;========================================================================================================================

; returns *a clause* for the constraint:
; "node n gets at least one color from the set {c,c+1,...,k}."
;
(defun at-least-one-color (n c k)
  (cond ((> c k) NIL)                         ; BASE CASE: color values must be < k
        ((< c 1) (at-least-one-color n 1 k))  ; INVALID INPUT CORRECTION: can only have positive color values
        
        ; recursively build the list of valid possible color values
        ; this list represents a clause which is the conjunction of color assignments
        (t (cons (node2var n c k) (at-least-one-color n (+ c 1) k)))
  )
)

;;;===========================================================================================================================
;;; AT-MOST-ONE-COLOR METHODS


; helper function for at-most-one-color
; returns a list of all pairs with 'front' as the first element and one element from the 'rest' list
(defun pairs (front rest)
  (cond ((= (length rest) 0) NIL)
        (t (cons (list front (car rest)) (pairs front (cdr rest))))
  )
)

; helper function for at-most-one-color
(defun all-pairs (s)
  (cond ((< (length s) 2) NIL)
        (t (append (pairs (car s) (cdr s)) (all-pairs (cdr s))))
  )
)

; helper function for at-most-one-color
; takes a list 's' of colors and returns a list with all values in s multiplied by -1
(defun negate (s)
  (cond ((= (length s) 0) s)
        (t (cons (* -1 (car s)) (negate (cdr s))))
  )
)

; returns *a list of clauses* for the constraint:
; "node n gets at most one color from the set {c,c+1,...,k}."
;
(defun at-most-one-color (n c k)
  ;cannot have any 2 elements from the set {c,c+1,...,k} simultaneously
  ; (a b c) ==> !(a ^ b) && !(a ^ c) && !(b ^ c) ==> (!a || !b) && (!a || !c) && (!b || !c)
  (let* 
    (
      (colors (at-least-one-color n c k))
      (negated_colors (negate colors))
    )    
    (cond ((< (length colors) 2) NIL)
          ((>= (length colors) 2) (all-pairs negated_colors))
    ) ;end cond
  ) ;end let*
)

;;;============================================================================================================================

; returns *a list of clauses* to ensure that
; "node n gets exactly one color from the set {1,2,...,k}."
;
(defun generate-node-clauses (n k)
  ; at-least-one-color && at-most-one-color = exactly one color
  (cons (at-least-one-color n 1 k) (at-most-one-color n 1 k))
)

;;;============================================================================================================================

; ensures that the two nodes connected by e can't both have color value c for all possible c in the set {1,2,...k}
; input parameter 'c' should be 1 when this method is initially called since variables should be able to take on values
;   between 1 and k
(defun edge-clause-helper (e c k)
  ;!(x(1) ^ y(1)) && !((x(2) ^ y(2)) && ... ==> (!x(1) || !y(1)) && (!x(2) || !y(2)) && ...
    (let* 
      (
        (x (car e))
        (y (cadr e))
      )
      (cond ((< k 1) NIL) ;BASE CASE (INVALID MAX COLOR VALUE)
            ((> c k) NIL) ;BASE CASE (TERMINATING INPUT)
            (t (cons (negate (list (node2var x c k) (node2var y c k))) (edge-clause-helper e (+ c 1) k)))
      ) ; end cond
    ) ; end let*
)

; returns *a list of clauses* to ensure that
; "the nodes at both ends of edge e cannot have the same color from the set {1,2,...,k}."
;
(defun generate-edge-clauses (e k)
    (edge-clause-helper e 1 k)
)



;;;========================================================================================================================
;;;========================================================================================================================
;;;========================================================================================================================
;;;========================================================================================================================
;;;========================================================================================================================
;;;========================================================================================================================
;;;========================================================================================================================

 
; Top-level function for converting the graph coloring problem
; of the graph defined in 'fname' using k colors into a SAT problem.
; The resulting SAT problem is written to 'out-name' in a simplified DIMACS format.
; (http://www.satcompetition.org/2004/format-solvers2004.html)
;
; This function also returns the cnf written to file.
; 
; *works only for k>0*
;
(defun graph-coloring-to-sat (fname out-name k)
  (progn
    (setf in-path (make-pathname :name fname))
    (setf in (open in-path :direction :input))
    (setq info (get-number-pair-from-string (read-line in) #\ ))
    (setq cnf nil)
    (do ((node 1
	       (+ node 1)
	       ))
	((> node (car info)))
      (setq cnf (append (generate-node-clauses node k) cnf))
      );end do
    (do ((line (read-line in nil 'eof)
	       (read-line in nil 'eof)))
	((eql line 'eof) (close in))
      (let ((edge (get-number-pair-from-string line #\ )))
	(setq cnf (append (generate-edge-clauses edge k) cnf))
	);end let
      );end do
    (close in)
    (write-cnf-to-file out-name (* (car info) k) cnf)
    (return-from graph-coloring-to-sat cnf)
    );end progn  
  );end defun

;
; A utility function for parsing a pair of integers.
; 
(defun get-number-pair-from-string (string token)
  (if (and string token)
      (do* ((delim-list (if (and token (listp token)) token (list token)))
            (char-list (coerce string 'list))
            (limit (list-length char-list))
            (char-count 0 (+ 1 char-count))
            (char (car char-list) (nth char-count char-list))
            )
           ((or (member char delim-list)
                (= char-count limit))
            (return
               (if (= char-count limit)
                   (list string nil)
                   (list (parse-integer (coerce (butlast char-list (- limit char-count))
                                 'string))
                         (parse-integer (coerce (nthcdr (+ char-count 1) char-list) 'string))
			 )))))))

;
; Writes clause to file handle 'out'.
;
(defun write-clause-to-file (out clause)
  (cond ((null clause) (format out "0~%"))
	(t (progn 
	     (format out "~A " (car clause))
	     (write-clause-to-file out (cdr clause))
	     );end progn
	   );end t
	);end cond
  );end defun

;
; Writes the formula cnf with vc variables to 'fname'.
;
(defun write-cnf-to-file (fname vc cnf)
  (progn
    (setf path (make-pathname :name fname))
    (setf out (open path :direction :output))
    (setq cc (length cnf))  
    (format out "p cnf ~A ~A~%" vc cc)
    (dolist (clause cnf)
      (write-clause-to-file out clause)
      );end dolist
    (close out)
    );end progn
  );end defun
