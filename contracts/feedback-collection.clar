;; Feedback Collection Contract
;; Records community input

(define-data-var admin principal tx-sender)
(define-data-var feedback-counter uint u0)

;; Data structure for feedback
(define-map feedback
  { feedback-id: uint }
  {
    initiative-id: uint,
    author: principal,
    content: (string-utf8 500),
    timestamp: uint,
    category: (string-utf8 50),
    sentiment: (string-utf8 20)
  }
)

;; Submit feedback
(define-public (submit-feedback
                (initiative-id uint)
                (content (string-utf8 500))
                (category (string-utf8 50))
                (sentiment (string-utf8 20)))
  (let ((feedback-id (var-get feedback-counter))
        (author tx-sender))
    (var-set feedback-counter (+ feedback-id u1))
    (ok (map-insert feedback
      { feedback-id: feedback-id }
      {
        initiative-id: initiative-id,
        author: author,
        content: content,
        timestamp: block-height,
        category: category,
        sentiment: sentiment
      }))
  )
)

;; Get feedback by ID
(define-read-only (get-feedback (feedback-id uint))
  (map-get? feedback { feedback-id: feedback-id })
)

;; Get total number of feedback entries
(define-read-only (get-feedback-count)
  (var-get feedback-counter)
)

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (var-set admin new-admin))
  )
)
