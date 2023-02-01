#!/usr/bin/env ruby
#= Code here is only visible to Ruby

println = puts
println "Hello from Ruby!"

=begin # Code here is only visible to Julia =#
puts = println
puts("Hello from Julia!")

#=
=end # Code here is visible to Julia and Ruby =#
println("Hello from Julia and Ruby!")
