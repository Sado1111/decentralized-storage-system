;; Decentralized-storage-system

;; Storage Variables And Maps
(define-data-var file-count uint u0)

(define-map cloud-files
  { identifier: uint }
  {
    file-name: (string-ascii 64),
    file-owner: principal,
    file-size: uint,
    upload-time: uint,
    description: (string-ascii 128),    
    tags: (list 10 (string-ascii 32))
  }
)

(define-map access-permissions
  { identifier: uint, user: principal }
  { has-access: bool }
)

;; Constant Definitions
(define-constant error-file-not-found (err u201))
(define-constant error-file-exists (err u202))
(define-constant error-name-invalid (err u203))
(define-constant error-size-invalid (err u204))
(define-constant error-not-authorized (err u205))
(define-constant error-invalid-recipient (err u206))
(define-constant admin-identity tx-sender)
(define-constant error-admin-only (err u200))
(define-constant error-invalid-access (err u207))
(define-constant error-access-denied (err u208))

;; Helper Functions
(define-private (does-file-exist (identifier uint))
  (is-some (map-get? cloud-files { identifier: identifier }))
)

(define-private (check-file-owner (identifier uint) (owner principal))
  (match (map-get? cloud-files { identifier: identifier })
    file-details (is-eq (get file-owner file-details) owner)
    false
  )
)

(define-private (retrieve-file-size (identifier uint))
  (default-to u0 
    (get file-size 
      (map-get? cloud-files { identifier: identifier })
    )
  )
)

;; Helper function to validate a single tag
(define-private (validate-tag (tag (string-ascii 32)))
  (and 
    (> (len tag) u0)
    (< (len tag) u33)
  )
)

;; Helper function to validate all tags
(define-private (validate-tags (tags (list 10 (string-ascii 32))))
  (and
    (> (len tags) u0)
    (<= (len tags) u10)
    (is-eq (len (filter validate-tag tags)) (len tags))
  )
)

;; Public Functions
(define-public (upload-new-file (file-name (string-ascii 64)) (file-size uint) (description (string-ascii 128)) (tags (list 10 (string-ascii 32))))
  (let
    (
      (identifier (+ (var-get file-count) u1))
    )
    (asserts! (> (len file-name) u0) error-name-invalid)
    (asserts! (< (len file-name) u65) error-name-invalid)
    (asserts! (> file-size u0) error-size-invalid)
    (asserts! (< file-size u1000000000) error-size-invalid)
    (asserts! (> (len description) u0) error-name-invalid)
    (asserts! (< (len description) u129) error-name-invalid)
    (asserts! (validate-tags tags) error-name-invalid)

    (map-insert cloud-files
      { identifier: identifier }
      {
        file-name: file-name,
        file-owner: tx-sender,
        file-size: file-size,
        upload-time: block-height,
        description: description,
        tags: tags
      }
    )

    (map-insert access-permissions
      { identifier: identifier, user: tx-sender }
      { has-access: true }
    )
    (var-set file-count identifier)
    (ok identifier)
    )
    )

    (define-public (change-file-owner (identifier uint) (new-owner principal))
    (let
    (
      (file-data (unwrap! (map-get? cloud-files { identifier: identifier }) error-file-not-found))
    )
    (asserts! (does-file-exist identifier) error-file-not-found)
    (asserts! (is-eq (get file-owner file-data) tx-sender) error-not-authorized)
    (map-set cloud-files
      { identifier: identifier }
      (merge file-data { file-owner: new-owner })
    )
    (ok true)
    )
    )

    (define-public (modify-file (identifier uint) (new-name (string-ascii 64)) (new-size uint) (new-description (string-ascii 128)) (new-tags (list 10 (string-ascii 32))))
    (let
    (
      (file-data (unwrap! (map-get? cloud-files { identifier: identifier }) error-file-not-found))
    )
    (asserts! (does-file-exist identifier) error-file-not-found)
    (asserts! (is-eq (get file-owner file-data) tx-sender) error-not-authorized)
    (asserts! (> (len new-name) u0) error-name-invalid)
    (asserts! (< (len new-name) u65) error-name-invalid)
    (asserts! (> new-size u0) error-size-invalid)
    (asserts! (< new-size u1000000000) error-size-invalid)
    (asserts! (> (len new-description) u0) error-name-invalid)
    (asserts! (< (len new-description) u129) error-name-invalid)
    (asserts! (validate-tags new-tags) error-name-invalid)

    (map-set cloud-files
      { identifier: identifier }
      (merge file-data { file-name: new-name, file-size: new-size, description: new-description, tags: new-tags })
    )
    (ok true)
    )
    )

    (define-public (remove-file (identifier uint))
    (let
    (
      (file-data (unwrap! (map-get? cloud-files { identifier: identifier }) error-file-not-found))
    )
    (asserts! (does-file-exist identifier) error-file-not-found)
    (asserts! (is-eq (get file-owner file-data) tx-sender) error-not-authorized)
    (map-delete cloud-files { identifier: identifier })
    (ok true)
    )
    )

