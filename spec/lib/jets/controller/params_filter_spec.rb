describe Jets::Controller::ParamsFilter do
  describe '.filter_values_from_hash' do

    let(:result) do
      described_class.filter_values_from_hash(filtered_values, hash_params)
    end

    let(:hash_params) do
      {
        password: "private_text",
        password_confirmation: 'private_text_wrong',
        name: 'Joe',
        bio: 'Ruby on jets!'
      }
    end

    context 'When filtered_parameters is not empty' do
      let(:filtered_values) { %i[password password_confirmation] }

      it 'Should return a new hash with filtered_parameters masked as [FILTERED]' do
        expect(result).to eq(
          password: '[FILTERED]',
          password_confirmation: '[FILTERED]',
          name: 'Joe',
          bio: 'Ruby on jets!'
        )
      end
    end

    context 'When filtered_parameters exist in nested hash' do
      let(:filtered_values) { %i[password password_confirmation] }

      let(:hash_params) { {user: super()} }

      it 'Should return a new hash with filtered_parameters masked as [FILTERED]' do
        expect(result).to eq(
          user: {
            password: '[FILTERED]',
            password_confirmation: '[FILTERED]',
            name: 'Joe',
            bio: 'Ruby on jets!'
          }
        )
      end
    end

    context 'When filtered_parameters exist in nested array' do
      let(:filtered_values) { %i[password password_confirmation] }

      let(:hash_params) do
        {
          users: [
            super(),
            {
              password: 'abc123',
              password_confirmation: 'abc123',
              name: 'Jack',
              bio: 'Lets go'
            }
          ]
        }
      end

      it 'Should return a new hash with filtered_parameters masked as [FILTERED]' do
        expect(result).to eq(
          users: [
            {
              password: '[FILTERED]',
              password_confirmation: '[FILTERED]',
              name: 'Joe',
              bio: 'Ruby on jets!'
            },
            {
              password: '[FILTERED]',
              password_confirmation: '[FILTERED]',
              name: 'Jack',
              bio: 'Lets go'
            }
          ]
        )
      end
    end

    context 'When filtered_parameters is empty' do
      let(:filtered_values) { [] }

      it 'Should return the original hash of params' do
        expect(result).to eq(hash_params)
      end
    end
  end

  describe '.filter_values_from_json' do

    let(:result) do
      described_class.filter_values_from_json(filtered_values, json_text)
    end

    let(:json_text) do
      JSON.dump(
        password: "private_text",
        password_confirmation: 'private_text_wrong',
        name: 'Joe',
        bio: 'Ruby on jets!'
      )
    end

    context 'When filtered_parameters is not empty' do
      let(:filtered_values) { %i[password password_confirmation] }

      it 'Should return a new json with filtered_parameters masked as [FILTERED]' do
        expect(result).to eq("{\"password\":\"[FILTERED]\",\"password_confirmation\":\"[FILTERED]\",\"name\":\"Joe\",\"bio\":\"Ruby on jets!\"}")
      end
    end

    context 'When filtered_parameters is empty' do
      let(:filtered_values) { [] }

      it 'Should return the original json text' do
        expect(result).to eq(json_text)
      end
    end

    context 'When json_text has wrong format' do
      let(:filtered_values) { %i[password password_confirmation] }
      let(:json_text) { "just a text" }

      it 'Should return a blank string' do
        expect(result).to eq("")
      end
    end
  end
end
