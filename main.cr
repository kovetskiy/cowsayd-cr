require "http/server"
require "process"
require "io/memory"
require "option_parser"


def main()
    port = 8080

    OptionParser.parse! do |parser|
        parser.banner = "Usage: cowsayd [options]"

        parser.on(
            "-l port",
            "--listen=port",
            "Specify port listen to"
        ) { |value| port = value.to_i }

        parser.on("-h", "--help", "Shut this help") {
            puts parser
            exit(0)
        }

        parser.invalid_option do |flag|
            STDERR.puts "ERROR: #{flag} is not a valid option."
            STDERR.puts parser
            exit(1)
        end

    end

    listen_and_serve port
end

def listen_and_serve(port : Int32)
    server = HTTP::Server.new do |context|
        response = cowsay(
            context.request.query_params.fetch("text", "Hello World")
        )

        context.response.content_type = "text/plain"
        context.response.print response
    end

    puts "Listening on :#{port}"
    server.listen(port)
end

def cowsay(text : String)
    output = IO::Memory.new
    process = Process.run("cowsay", args: {text}, output: output)
    output.close
    return  output.to_s
end

main
