# Babbas - A Ruby IndieWeb Media Endpoint, for Micropub

Babbas is a Media endpoint for use with an IndieWeb [Micropub](http://micropub.rocks/) endpoint. It is written in Ruby, as a [Sinatra](http://sinatrarb.com/) application, and supports IndieAuth authorisation, as well as being [content-addressable](https://en.wikipedia.org/wiki/Content-addressable_storage).

## Requirements

* Ruby - the latest version (or one version back).

## Installation

Babbas is currently used as the Media endpoint for my personal website (https://deeden.co.uk/) and, as such, is configured to work for me. It should work for someone else if properly configured (via `.env`). For my purposes I run Babbas through [Passenger](https://www.phusionpassenger.com/) on a [Dreamhost VPS](https://www.dreamhost.com/hosting/vps/).

## Configuration

### Environment variables

Use of the application **requires** a number of environment variables to be specified, while others are optional. It does support [dotenv](https://github.com/bkeepers/dotenv) if that floats your boat.

#### Required

| Variable | Format | Purpose |
| -------- | ------ | ------- |
| ENDPOINT_URL | URL | The domain you want to serve media from. For example, I serve the files from `https://media.deeden.co.uk` |
| ENDPOINT_BASE | Directory path | The base directory for where your media will be stored. |
| DATA_DIRECTORY | Directory path | A more specific directory (within `ENDPOINT_BASE`) for where your media will be stored. |
| TOKEN_ENDPOINT | URL | The token endpoint used to verify any IndieAuth token |
| DOMAIN | URL | The domain any IndieAuth token will be verified to be valid for |

##### `ENDPOINT_BASE` vs `DATA_DIRECTORY`

What is the difference between `ENDPOINT_BASE` and `DATA_DIRECTORY`, you ask?

Let's say that you want to store your media in the `/www/media/` directory, and have your media links served from the root of a site, such as `https://example.com/`. In that case you would set the following values (similar to what I use)...

| Variable | Value |
| -------- | ----- |
| ENDPOINT_URL | `https://example.com/` |
| ENDPOINT_BASE | `/www/media` |
| DATA_DIRECTORY | None/Unset |

However maybe you'd prefer to serve your media from a different path, such as `https://example.com/photos/`. In this case you could configure it as follows...

| Variable | Value |
| -------- | ----- |
| ENDPOINT_URL | `https://example.com/` |
| ENDPOINT_BASE | `/www/media` |
| DATA_DIRECTORY | `photos` |

This results in `photos` being included correctly included in both the path used to save the file, and the url used to refer to the file.

##### Token Verification environment variables

Babbas uses the [IndieAuth::TokenVerification](https://github.com/srushe/indieauth-token-verification/) ruby gem to verify an IndieAuth access token against a token endpoint, and the `TOKEN_ENDPOINT` and `DOMAIN` environment variables are required by that gem.

`TOKEN_ENDPOINT` specifies the token endpoint to be used to validate the access token. Failure to specify `TOKEN_ENDPOINT` will result in a `IndieAuth::TokenVerification::MissingTokenEndpointError` error being raised.

`DOMAIN` specifies the domain we expect to see in the response from the validated token. It should match that specified when the token was first generated (presumably your website URL). Failure to specify `DOMAIN` will result in a `IndieAuth::TokenVerification::MissingDomainError` error being raised.

## Contributing

While Babbas is written with a view to "[self-dogfooding](https://indieweb.org/selfdogfood)" I'm still happy for other people to use and contribute to the project. Bug reports and pull requests are welcome on GitHub at https://github.com/srushe/babbas. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

This application is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Babbas?

![Babbas, a genie from Yonderland](static/babbas.png)

Babbas is a genie from the TV series [Yonderland](https://en.wikipedia.org/wiki/Yonderland). He is tasked with looking after a video message for one of the lead characters, hence his use as the name for my media endpoint.
