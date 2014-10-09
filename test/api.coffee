should = require 'should'
config = require 'config'
APIKeyService = require '../src/api_key_service'

expectedKey = config.get('test_character_api_key')
throw "No test character key setup! run 'npm run bootstrap' to create a test character API key" if not expectedKey

describe 'character api key information', ->
  before (done) ->
    apiKeyService = new APIKeyService(expectedKey.keyId, expectedKey.vCode)
    apiKeyService.getAPIKeyInformation((error, apiKey) =>
      throw error if error
      @apiKey = apiKey
      done()
    )


  it 'should have a type', ->
    @apiKey.keyType.should.equal expectedKey.keyType

  it 'should have an access mask', ->
    @apiKey.accessMask.should.equal expectedKey.accessMask

  it 'should have an expiry', ->
    @apiKey.expiry.should.equal expectedKey.expiry
