require_relative '../../automated_init'

context "Write" do
  context "Message" do
    context "Writing the initial event to a stream that has not been created yet" do
      stream_name = Controls::StreamName.example(category: 'testWriteInitialMessage')

      message = Controls::Message.example

      writer = Messaging::Postgres::Write.build

      writer.write_initial(message, stream_name)

      read_event = EventSource::Postgres::Get.(stream_name, position: 0, batch_size: 1).first

      test "Writes the message" do
        assert(read_event.data == message.to_h)
      end
    end

    context "Writing the initial event to a stream that already exists" do
      stream_name = Controls::StreamName.example

      message = Controls::Message.example

      writer = Messaging::Postgres::Write.build

      writer.write(message, stream_name)

      test "Is an error" do
        assert proc { writer.write_initial(message, stream_name) } do
          raises_error? EventSource::ExpectedVersion::Error
        end
      end
    end
  end
end