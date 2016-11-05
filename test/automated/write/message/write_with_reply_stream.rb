require_relative '../../automated_init'

context "Write" do
  context "Message" do
    context "With Reply Stream" do
      message = Controls::Message.example

      stream_name = Controls::StreamName.example(category: 'testReply')
      reply_stream_name = Controls::StreamName.example(category: 'testReplyTo')

      written_position = Write.(message, stream_name, reply_stream_name: reply_stream_name)

      read_event = EventSource::Postgres::Get.(stream_name, position: written_position, batch_size: 1).first

      test "Sets the metadata reply stream name" do
        assert(read_event.metadata[:reply_stream_name] == reply_stream_name)
      end
    end
  end
end