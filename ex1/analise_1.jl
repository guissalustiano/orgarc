using ArgParse
using JSON
using Plots
using Measurements

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "file"
            help = "output from hyperfine --export-json <result_file>"
            required = true
    end

    return parse_args(s)
end

function main()
    parsed_args = parse_commandline()
    hyperfine_output = JSON.parsefile(parsed_args["file"])
    results = hyperfine_output["results"]
    data = map(d -> (d["command"], d["mean"] ± d["stddev"]), results)
    println(data)
    bar(data, label="")
    savefig("plot.png")
end

main()
