;; welsh-stone
;; contractType: public

(impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

(define-non-fungible-token welsh-stone uint)
;; Constants
(define-constant DEPLOYER tx-sender)
(define-constant COMM u1000)
(define-constant COMM-ADDR 'SPNWZ5V2TPWGQGVDR6T7B6RQ4XMGZ4PXTEE0VQ0S)

(define-constant ERR-NO-MORE-NFTS u100)
(define-constant ERR-NOT-ENOUGH-PASSES u101)
(define-constant ERR-PUBLIC-SALE-DISABLED u102)
(define-constant ERR-CONTRACT-INITIALIZED u103)
(define-constant ERR-NOT-AUTHORIZED u104)
(define-constant ERR-INVALID-USER u105)
(define-constant ERR-LISTING u106)
(define-constant ERR-WRONG-COMMISSION u107)
(define-constant ERR-NOT-FOUND u108)
(define-constant ERR-PAUSED u109)
(define-constant ERR-MINT-LIMIT u110)
(define-constant ERR-METADATA-FROZEN u111)
(define-constant ERR-AIRDROP-CALLED u112)
(define-constant ERR-NO-MORE-MINTS u113)
(define-constant ERR-INVALID-PERCENTAGE u114)

;; Internal variables
(define-data-var mint-limit uint u500) ;; limit for minting anything
(define-data-var last-id uint u1) 
(define-data-var total-price uint u6900000) ;; 
(define-data-var artist-address principal 'SPQ5CEHETP8K4Q2FSNNK9ANMPAVBSA9NN86YSN59)
;; where all the metada of the collection is being stored
(define-data-var ipfs-root (string-ascii 80) "ipfs://ipfs/QmUatY92q2hmUrkSksD3C5ATU1RG79uNmB9vPvPxypJgtA/json/")
(define-data-var mint-paused bool false)
(define-data-var premint-enabled bool false)
(define-data-var sale-enabled bool false)
(define-data-var metadata-frozen bool false)
(define-data-var airdrop-called bool false)
(define-data-var mint-cap uint u0)

(define-map mints-per-user principal uint)
(define-map mint-passes principal uint)

(define-public (claim) 
  (mint (list true)))

(define-public (claim-two) (mint (list true true)))

(define-public (claim-three) (mint (list true true true)))

(define-public (claim-four) (mint (list true true true true)))

(define-public (claim-five) (mint (list true true true true true)))

(define-public (claim-six) (mint (list true true true true true true)))

(define-public (claim-seven) (mint (list true true true true true true true)))

(define-public (claim-eight) (mint (list true true true true true true true true)))

(define-public (claim-nine) (mint (list true true true true true true true true true)))

(define-public (claim-ten) (mint (list true true true true true true true true true true)))

(define-public (claim-fifteen) (mint (list true true true true true true true true true true true true true true true)))

(define-public (claim-twenty) (mint (list true true true true true true true true true true true true true true true true true true true true)))

(define-public (claim-twentyfive) (mint (list true true true true true true true true true true true true true true true true true true true true true true true true true)))

;; Default Minting
(define-private (mint (orders (list 25 bool)))
  (mint-many orders))

(define-private (mint-many (orders (list 25 bool )))  
  (let ;; open a local scope for local variables
    (
      (last-nft-id (var-get last-id)) ;; retrieve the last identifier
      (enabled (asserts! (<= last-nft-id (var-get mint-limit)) (err ERR-NO-MORE-NFTS))) ;; verifies that there are no more mints than permitted
      (art-addr (var-get artist-address)) ;; get the address of the artist
      (id-reached (fold mint-many-iter orders last-nft-id)) ;; <func sequence initial value> <-- this is like a for of length "orders" 
                                                            ;; it's like a for for creating nfts
                                                            ;; id-reached is the amount of nfts created all the way to this point
      (price (* (var-get total-price) (- id-reached last-nft-id)))
                                        ;; (- id-reached last-nft-id) is the amount of nfts created at this instance
      (total-commission (/ (* price COMM) u10000)) ;; since COMM is 1000 this is like taking the 10% of the price
                                        ;; this is the comission for the smart-contract?
      (current-balance (get-balance tx-sender)) ;; get the amount of nfts that the sender of the transaction has
      (total-artist (- price total-commission))
                                        ;; this is the amount of money that will be bided to the artist
      (capped (> (var-get mint-cap) u0))
                                        ;; verify that the minting process is inside a certain time frame
      (user-mints (get-mints tx-sender))
                                        ;; get the amount of mints done by the sender of the transaction
    )
    (asserts! 
        (or 
            (is-eq false (var-get mint-paused)) ;; process of minting was not paussed
            (is-eq tx-sender DEPLOYER)          ;; the sender of the transaction must be the owner of the smart contract
        ) 
        (err ERR-PAUSED)                        ;; ortherwise return ERR-PAUSED
    )
    (asserts! 
        (or 
            (not capped)                        ;; time-frame limit has not been met
            (is-eq tx-sender DEPLOYER)          ;; the sender of the transaction is the deployer
            (is-eq tx-sender art-addr)          ;; verifying that the sender of the transaction is the artist
            (>= (var-get mint-cap) (+ (len orders) user-mints) ) ;; verifying that the user doesn't suprass the limit of feasible generated tokens by the user
        ) 
        (err ERR-NO-MORE-MINTS)                 ;; of all the prior fails it is becuase it's not possible no make more mints
    )
    (map-set mints-per-user tx-sender (+ (len orders) user-mints)) ;; add the amount of nfts generated to the user register in the map
    (if (or (is-eq tx-sender art-addr) (is-eq tx-sender DEPLOYER) (is-eq (var-get total-price) u0000000))
            ;;; if the sender is the artist or if it's the deployer or if the price is free
      (begin
        (var-set last-id id-reached)                                                    ;; update the last-id reached
        (map-set token-count tx-sender (+ current-balance (- id-reached last-nft-id)))  ;; update the amount of tokens that the tx-sender has 
      )
      (begin
        (var-set last-id id-reached)  ;; update the last id
        (map-set token-count tx-sender (+ current-balance (- id-reached last-nft-id)))  ;; update the amount of minted tokens
        (try! (stx-transfer? total-artist tx-sender (var-get artist-address)))          ;; transfer the total amount of money to the artist
        (try! (stx-transfer? total-commission tx-sender COMM-ADDR))                     ;; transfer the total amount of money to the commission address
      )    
    )
    (ok id-reached))) ;; return the id reached

(define-private (mint-many-iter (ignore bool) (next-id uint))   ;; actual function to mint but as many times as the orders array state
                                                                ;; ignore argument doesn't do anything
  (if (<= next-id (var-get mint-limit)) ;; if there are less nfts than the limit we settled
    (begin ;; NB: it will return the last expression
            ;; NB: type (response ok-type err-type) <- i    
      (unwrap! (nft-mint? welsh-stone next-id tx-sender) next-id) ;; unwraps the boolean that nft-mint? returned (overmore this last operation creates a welsh-stone <class> with id next-id <uint> and bids it to the wallet that sent the transaction)
        ;; in case that the nft-mint returned an error, or what is the same: there's already a token with that id
      (+ next-id u1) ;; increase next-id <- this is what is being yielded by the private function
    )
    next-id) ;; if the limit of nfts has been reached
)

(define-public (set-artist-address (address principal))
  (begin
      ;; returns true if the sender of the transaction is the artist or the deployer, otherwise returns ERR-INVALID-USER
    (asserts! (or (is-eq tx-sender (var-get artist-address)) (is-eq tx-sender DEPLOYER)) (err ERR-INVALID-USER))
      ;; update the artist address
    (ok (var-set artist-address address))))

(define-public (set-price (price uint)) ;; function to set the price of the nft
  (begin
    (asserts! (or (is-eq tx-sender (var-get artist-address)) (is-eq tx-sender DEPLOYER)) (err ERR-INVALID-USER)) ;; validate user
    (ok (var-set total-price price)))) ;; renew the total-price variable

(define-public (toggle-pause) ;; toggle mint-paused variable
  (begin
    (asserts! (or (is-eq tx-sender (var-get artist-address)) (is-eq tx-sender DEPLOYER)) (err ERR-INVALID-USER))
    (ok (var-set mint-paused (not (var-get mint-paused))))))

(define-public (set-mint-limit (limit uint)) ;; set the limit of minted tokens
  (begin
    (asserts! (or (is-eq tx-sender (var-get artist-address)) (is-eq tx-sender DEPLOYER)) (err ERR-INVALID-USER))  ;; verify tx-sender
    (asserts! (< limit (var-get mint-limit)) (err ERR-MINT-LIMIT))                                                ;; not update if the values is lesser than the one there was before
    (ok (var-set mint-limit limit)))) ;; update the variable

(define-public (burn (token-id uint)) ;; burn the token of certain id
  (begin 
    (asserts! (is-owner token-id tx-sender) (err ERR-NOT-AUTHORIZED))
    (asserts! (is-none (map-get? market token-id)) (err ERR-LISTING))
    (nft-burn? welsh-stone token-id tx-sender)))

(define-private (is-owner (token-id uint) (user principal))
    (is-eq user (unwrap! (nft-get-owner? welsh-stone token-id) false)))

(define-public (set-base-uri (new-base-uri (string-ascii 80)))
  (begin
    (asserts! (or (is-eq tx-sender (var-get artist-address)) (is-eq tx-sender DEPLOYER)) (err ERR-NOT-AUTHORIZED))
    (asserts! (not (var-get metadata-frozen)) (err ERR-METADATA-FROZEN))
    (print { notification: "token-metadata-update", payload: { token-class: "nft", contract-id: (as-contract tx-sender) }})
    (var-set ipfs-root new-base-uri)
    (ok true)))

(define-public (freeze-metadata)
  (begin
    (asserts! (or (is-eq tx-sender (var-get artist-address)) (is-eq tx-sender DEPLOYER)) (err ERR-NOT-AUTHORIZED))
    (var-set metadata-frozen true)
    (ok true)))

    ;; Non-custodial SIP-009 transfer function
(define-public (transfer (id uint) (sender principal) (recipient principal)) ;; function to asure that the is the one passed as argument
  (begin
    (asserts! (is-eq tx-sender sender) (err ERR-NOT-AUTHORIZED))  ;; non authorized user
    (asserts! (is-none (map-get? market id)) (err ERR-LISTING))   ;; the token is not listed
    (trnsfr id sender recipient)))


;; read-only functions
(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? welsh-stone token-id)))

(define-read-only (get-last-token-id)
  (ok (- (var-get last-id) u1)))

;; here is where the metadata is "assigned"
(define-read-only (get-token-uri (token-id uint))
  (ok (some (concat (concat (var-get ipfs-root) "{id}") ".json"))))

(define-read-only (get-paused)
  (ok (var-get mint-paused)))

(define-read-only (get-price)
  (ok (var-get total-price)))

(define-read-only (get-artist-address)
  (ok (var-get artist-address)))

(define-read-only (get-mints (caller principal))
  (default-to u0 (map-get? mints-per-user caller))) ;; retrieves the amount of mints done by a single address

(define-read-only (get-mint-limit)
  (ok (var-get mint-limit)))

(define-data-var license-uri (string-ascii 80) "")
(define-data-var license-name (string-ascii 40) "")

(define-read-only (get-license-uri)
  (ok (var-get license-uri)))
  
(define-read-only (get-license-name)
  (ok (var-get license-name)))
  
(define-public (set-license-uri (uri (string-ascii 80)))
  (begin
    (asserts! (or (is-eq tx-sender (var-get artist-address)) (is-eq tx-sender DEPLOYER)) (err ERR-NOT-AUTHORIZED))
    (ok (var-set license-uri uri))))
    
(define-public (set-license-name (name (string-ascii 40)))
  (begin
    (asserts! (or (is-eq tx-sender (var-get artist-address)) (is-eq tx-sender DEPLOYER)) (err ERR-NOT-AUTHORIZED))
    (ok (var-set license-name name))))

;; Non-custodial marketplace extras
(use-trait commission-trait 'SP3D6PV2ACBPEKYJTCMH7HEN02KP87QSP8KTEH335.commission-trait.commission)

(define-map token-count principal uint)
(define-map market uint {price: uint, commission: principal, royalty: uint})

(define-read-only (get-balance (account principal)) ;; retrieves the amount of tokens that a principal has
  (default-to u0
    (map-get? token-count account)))

(define-private (trnsfr (id uint) (sender principal) (recipient principal)) ;; actual transfer function
  (match (nft-transfer? welsh-stone id sender recipient)                    ;; <input ok-binding-name ok-branch err-binding-name err-branch>
    success ;; this is where the input is saved in case of ok response
      (let
        ((sender-balance (get-balance sender))          ;; amount of tokens that the sender has
        (recipient-balance (get-balance recipient)))    ;; amount of tokens that the recipient has
          (map-set token-count
            sender ;; sender has one less token
            (- sender-balance u1))
          (map-set token-count
            recipient ;; recipent has one more token
            (+ recipient-balance u1))
          (ok success))
    error ;; this is where the input is saved in case of error
      (err error)))

(define-private (is-sender-owner (id uint))
  (let ((owner (unwrap! (nft-get-owner? welsh-stone id) false)))
    (or (is-eq tx-sender owner) (is-eq contract-caller owner))))

(define-read-only (get-listing-in-ustx (id uint))
  (map-get? market id))

(define-public (list-in-ustx (id uint) (price uint) (comm-trait <commission-trait>))
  (let ((listing  {price: price, commission: (contract-of comm-trait), royalty: (var-get royalty-percent)}))
    (asserts! (is-sender-owner id) (err ERR-NOT-AUTHORIZED))
    (map-set market id listing)
    (print (merge listing {a: "list-in-ustx", id: id}))
    (ok true)))

(define-public (unlist-in-ustx (id uint))
  (begin
    (asserts! (is-sender-owner id) (err ERR-NOT-AUTHORIZED))
    (map-delete market id)
    (print {a: "unlist-in-ustx", id: id})
    (ok true)))

(define-public (buy-in-ustx (id uint) (comm-trait <commission-trait>))
  (let ((owner (unwrap! (nft-get-owner? welsh-stone id) (err ERR-NOT-FOUND)))
      (listing (unwrap! (map-get? market id) (err ERR-LISTING)))
      (price (get price listing))
      (royalty (get royalty listing)))
    (asserts! (is-eq (contract-of comm-trait) (get commission listing)) (err ERR-WRONG-COMMISSION))
    (try! (stx-transfer? price tx-sender owner))
    (try! (pay-royalty price royalty))
    (try! (contract-call? comm-trait pay id price))
    (try! (trnsfr id owner tx-sender))
    (map-delete market id)
    (print {a: "buy-in-ustx", id: id})
    (ok true)))
    
(define-data-var royalty-percent uint u500)

(define-read-only (get-royalty-percent)
  (ok (var-get royalty-percent)))

(define-public (set-royalty-percent (royalty uint))
  (begin
    (asserts! (or (is-eq tx-sender (var-get artist-address)) (is-eq tx-sender DEPLOYER)) (err ERR-INVALID-USER))
    (asserts! (and (>= royalty u0) (<= royalty u1000)) (err ERR-INVALID-PERCENTAGE))
    (ok (var-set royalty-percent royalty))))

(define-private (pay-royalty (price uint) (royalty uint))
  (let (
    (royalty-amount (/ (* price royalty) u10000))
  )
  (if (and (> royalty-amount u0) (not (is-eq tx-sender (var-get artist-address))))
    (try! (stx-transfer? royalty-amount tx-sender (var-get artist-address)))
    (print false)
  )
  (ok true)))