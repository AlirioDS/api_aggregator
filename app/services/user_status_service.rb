class UserStatusService
    BASE_URL = "https://dummyjson.com"

    def initialize(id)
        @id = id
    end

    def call
        return { error: "User not found" } unless user_exists?

        {
            full_name: full_name,
            experience: experience,
            todo_summary: todo_summary
        }
    end

    private

    def full_name
        "#{user['firstName']} #{user['lastName']}"
    end

    def experience
        user["age"] > 50 ? "Veteran" : "Rookie"
    end

    def todo_summary
        {
            pending_task_count: pending_todos.count,
            next_urgent_task: pending_todos.first&.dig("todo")
        }
    end

    def pending_todos
        @pending_todos ||= todos["todos"].select { |t| t["completed"] == false } || []
    end

    def user
        @user ||= HTTParty.get("#{BASE_URL}/users/#{@id}")
    rescue StandardError => e
        {"error" => e.message}
    end

    def todos
        @todos ||= HTTParty.get("#{BASE_URL}/todos/user/#{@id}")
    rescue StandardError => e
        Rails.logger.error('Todos not found', error: e)
        {"todo" => []}
    end

    def user_exists?
        user["id"].present?
    end
end