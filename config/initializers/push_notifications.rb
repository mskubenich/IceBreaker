$ios_pusher = Grocer.pusher(
    certificate: "#{Rails.root}/app/assets/certificates/ck.pem",
    passphrase:  "123456",                 # optional
    gateway:     "gateway.push.apple.com", # optional; See note below.
    port:        2195,                     # optional
    retries:     3                         # optional
)
