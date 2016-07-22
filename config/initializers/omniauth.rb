OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '1013416068776625', 'eca8a7c0346e2161105385055cc4f5c7', {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
end
