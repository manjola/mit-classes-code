;;;Project 1 Code
;;;Manushaqe Muco (manjola@mit.edu)

;;a & b & c
(define ((T-dual-pend m1 m2 g) local)
  (let ((v (velocity local)))
    (let ((v1 (ref v 0))
	  (v2 (ref v 1)))
      (* 1/2 
	 (+ (* m1 (square v1))
	    (* m2 (square v2)))))))

(define ((V-dual-pend m1 m2 g) local)
 (let ((q (coordinate local)))
   (+ (* m1 g (ref q 0 1))
      (* m2 g (ref q 1 1)))))

(define L-dual-pend (- T-dual-pend V-dual-pend))

;;change coordinates to generalized coords and constants
(define ((dual-pend-coordinates l1 l2) local)
  (let ((theta (coordinate local)))
    (let ((theta1 (ref theta 0))
	  (theta2 (ref theta 1)))
      (let* ((x1 (* l1 (sin theta1)))
	     (y1 (* -1 l1 (cos theta1)))
	     (x2 (+ x1 (* l2 (sin (+ theta1 theta2)))))
	     (y2 (- y1 (* l2 (cos (+ theta1 theta2))))))
	(up (up x1 y1) (up x2 y2))))))

(define (L m1 m2 l1 l2 g)
  (compose (L-dual-pend m1 m2 g)
	   (F->C (dual-pend-coordinates l1 l2))))

(define (dual-pend-state-deriv m1 m2 l1 l2 g)
  (Lagrangian->state-derivative (L m1 m2 l1 l2 g)))

(define pend1-theta2-list '())
 ;;we'll use this in part d

(define ((monitor-theta1 win) state)
  (let ((theta1 ((principal-value :pi) (ref (coordinate state) 0))))
    (plot-point win (time state) theta1)))

(define ((monitor-theta2  win) state)
  (let ((theta2 ((principal-value :pi) (ref (coordinate state) 1))))
    (set! pend1-theta2-list (append pend1-theta2-list (list theta2)))
    (plot-point win (time state) theta2)))

(define theta-win (frame 0. 50. :-pi :pi))

(define (energy m1 m2 l1 l2 g)
  (compose ((+ T-dual-pend V-dual-pend) m1 m2 g)
	   (F->C (dual-pend-coordinates l1 l2))))

(define energy-win (frame 0. 50. -1e-10 1e-10))

(define ((monitor-energy win) state)
   (let ((e ((energy m1 m2 l1 l2 g) state)))
     (plot-point win (time state) e)))

((evolve dual-pend-state-deriv
	 1.0 3.0 1.0 0.9 9.8)
 (up 0.0 (up :pi/2 0.0) (up 0.0 0.0))
 (monitor-theta1 theta-win)
 0.005
 50.0
1.0e-13)

;;d & e
(define i -1)

(define plot-diffs-win (frame 0 50 -50 3))

(define ((monitor2-theta2 win) state)
  (let ((theta2 ((principal-value :pi) (ref (coordinate state) 1))))
    (set! i (+ i 1))
    (plot-point win (time state) 
		(log (square (- theta2 (ref pend1-theta2-list i)))))))

((evolve dual-pend-state-deriv
	 1.0 3.0 1.0 0.9 9.8)
 (up 0 (up :pi/2  (+ 0.0 (/ 1.e-10 .9))) (up 0 0))
 (monitor2-theta2 plot-diffs-win)
 0.005
 50.0
1.0e-13)



