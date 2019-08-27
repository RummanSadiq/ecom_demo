Rails.configuration.stripe = {
  :publishable_key => "pk_test_cDrAFxGn2K7mHOIKnRV3edui00QGpR7iRa",
  :secret_key => "sk_test_2nLK3rGEn14bFd9Ga7bZbH0e00FTHsbITC",
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
