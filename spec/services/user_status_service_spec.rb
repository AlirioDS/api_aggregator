require "rails_helper"

RSpec.describe UserStatusService do
    let(:user_response) do
        '{"id":1,"firstName":"Alirio","lastName":"Diaz","age":29}'
    end

    let(:todos_response) do
        '{"todos":[{"id":47,"todo":"Learn Ruby","completed":false,"userId":1},{"id":64,"todo":"Create a tests","completed":true,"userId":1}]}'
    end

    let(:headers) do
        { "Content-Type" => "application/json" }
    end

    before do
        stub_request(:get, "https://dummyjson.com/users/1")
          .to_return(status: 200, body: user_response, headers: headers)

        stub_request(:get, "https://dummyjson.com/todos/user/1")
          .to_return(status: 200, body: todos_response, headers: headers)
    end

    it "return full_name combining firstName and lastName"do
        result = described_class.new(1).call
        expect(result[:full_name]).to eq("Alirio Diaz")
    end

    it "returns Rookie when age is under 50" do
        result = described_class.new(1).call
        expect(result[:experience]).to eq("Rookie")
    end

    it "saves to UserStatus table" do
        expect {
            described_class.new(1).call
    }.to change(UserStatus, :count).by(1)
    end

    it "saves correct data to UserStatus" do
        described_class.new(1).call
        record = UserStatus.last

        expect(record.full_name).to eq("Alirio Diaz")
        expect(record.experience).to eq("Rookie")
        expect(record.pending_task_count).to eq(1)
        expect(record.next_urgent_task).to eq("Learn Ruby")
    end

    context "when age is over 50" do
        let(:user_response) do
            '{"id":1,"firstName":"Carlos","lastName":"Linares","age":55}'
        end

        it "return Veteran" do 
            result = described_class.new(1).call
            expect(result[:experience]).to eq("Veteran")
        end

        it "returns pending task count" do
            result = described_class.new(1).call
            expect(result[:pending_task_count]).to eq(1)
        end

        it "returns next urgent task" do
            result = described_class.new(1).call
            expect(result[:next_urgent_task]).to eq("Learn Ruby")
        end

        context "when user does not exist" do
            before do
                stub_request(:get, "https://dummyjson.com/users/999")
                    .to_return(status: 404, body: '{ "message": "User not found" }', headers: headers)
            end

            it "returns error" do
                result = described_class.new(999).call
                expect(result[:error]).to eq("User not found")
            end
        end

        context "when API is down" do
            before do
                stub_request(:get, "https://dummyjson.com/users/1").to_timeout
            end

            it "returns error" do
                result = described_class.new(1).call
                expect(result[:error]).to eq("User not found")
            end
        end
    end
end