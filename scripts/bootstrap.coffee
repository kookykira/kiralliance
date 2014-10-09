prompt = require 'prompt'
fileSystem = require 'fs'
path = require 'path'
APIKeyService = require '../src/api_key_service'

console.log('In order to properly run tests, this project requires a test ' +
            'EVE character API key setup.')
console.log('Please create one now at https://community.eveonline.com/support/api-key/.\n')


prompt.message = 'Test Character API Key'

prompt.start()
prompt.get([name: 'Key Id', 'Verification Code'], (error, results) ->
  throw error if error

  apiKeyService = new APIKeyService(results['Key Id'], results['Verification Code'])
  apiKeyInformation = apiKeyService.getAPIKeyInformation((error, apiKeyInformation) ->
    apiKeyInformation.keyId = results['Key Id']
    apiKeyInformation.vCode = results['Verification Code']

    configuration =
      test_character_api_key: apiKeyInformation

    configDirectory = path.join(__dirname, '..', 'config')
    fileSystem.mkdirSync(configDirectory) if not fileSystem.existsSync(configDirectory)

    configFile = path.join(configDirectory, 'default.json')
    fileSystem.writeFileSync(configFile, JSON.stringify(configuration))

    console.log('Successfully saved the test character API key.')
    console.log('Bootstrapping complete.')
  )
)
