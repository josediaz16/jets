class Jets::Controller
  class ParamsFilter
    FILTERED = '[FILTERED]'.freeze

    # Takes a list of keys and a hash and returns a new
    # hash with corresponding values marked as FILTERED
    def self.filter_values_from_hash(filtered_values:, hash_params:)
      return hash_params if filtered_values.empty?

      hash_params.tap do |params|
        [*filtered_values].each do |filtered_value|
          params[filtered_value] = FILTERED if params[filtered_value].present?
        end
      end
    end

    # Takes a list of keys and a json string and returns a new
    # string with corresponding values marked as FILTERED
    def self.filter_values_from_json(filtered_values:, json_text:)
      return json_text if filtered_values.empty?

      begin
        hash_params = JSON.parse(json_text, symbolize_names: true)
        filtered_params = filter_values_from_hash(filtered_values: filtered_values, hash_params: hash_params) 

        JSON.dump(filtered_params)
      rescue JSON::ParserError
        String.new
      end
    end
  end
end
