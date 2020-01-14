describe Jets::Controller::ParamsFilter do
  describe '.filter_values_from_hash' do

    let(:result) do
      described_class.filter_values_from_hash(
        filtered_values: filtered_values,
        params: params
      )
    end

    let(:params) do
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

    context 'When filtered_parameters is empty' do
      let(:filtered_values) { [] }

      it 'Should return the original hash of params' do
        expect(result).to eq(params)
      end
    end
  end
end
