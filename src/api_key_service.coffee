APIKeyInformation = require './api_key_information'
RestClient = require('node-rest-client').Client
parseXml = require('xml2js').parseString

eveApi = 'https://api.eveonline.com'
apiKeyInformation = eveApi + '/account/APIKeyInfo.xml.aspx'

restClient = new RestClient
restClient.registerMethod('getAPIKeyInformation', apiKeyInformation, 'GET')

class APIKeyService
  constructor: (@keyId, @vCode) ->
    @rest_client = new RestClient

  getAPIKeyInformation: (callback) ->
    parameters =
      KeyId: @keyId
      vCode: @vCode

    restClient.methods.getAPIKeyInformation({parameters: parameters}, (responseData) ->
      parseXml(responseData, (error, jsonData) ->
        callback(error) if error

        apiKey = jsonData.eveapi.result[0].key[0]['$']
        keyType = apiKey['type']
        accessMask = apiKey.accessMask
        expiry = Date.parse(apiKey.expires) if apiKey.expires isnt ''
        apiKeyInformation = new APIKeyInformation(keyType, accessMask, expiry)
        callback(null, apiKeyInformation)
      )
    )

module.exports = APIKeyService