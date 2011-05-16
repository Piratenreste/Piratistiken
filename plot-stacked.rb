#!/usr/bin/env ruby
# Mix member data of input files to stdout using partial sums.
#
# (C) 2011, Stephan Beyer
#
# Redistribution and use in source and binary forms, with or
# without modification, are permitted provided that the following
# conditions are met:
#
#   1. Redistributions of source code must retain the above
#      copyright notice, this list of conditions and the
#      following disclaimer.
#
#   2. Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the
#      following disclaimer in the documentation and/or other
#      materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY STEPHAN BEYER ``AS IS'' AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL STEPHAN BEYER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation
# are those of the authors and should not be interpreted as representing
# official policies, either expressed or implied, of Stephan Beyer.


# Do something for each date given by current_idx and input...
# Note that current_idx is changed to the next suitable value.
def each_current_date(current_idx, input)
	current_idx.each_with_index do |j,i|
		str = input[i][j]
		unless str.nil?
			tmp = str.match(/^([0-9]+)\t([0-9]+)/)
			while tmp.nil?
				j = current_idx[i] += 1
				tmp = input[i][j].match(/^([0-9]+)\t([0-9]+)/)
			end
			date = tmp[1].to_i
			val = tmp[2].to_i
			yield(date, val, i)
		end
	end
end

# read input files
input = []
ARGV.each do |fn|
	input << File.readlines(fn)
end

# init
current_idx = [0]*ARGV.length
current = [0]*ARGV.length

# combine input files and sum up from left to right
current_date = nil
loop do
	# initialize date to minimum date
	current_date = nil
	each_current_date(current_idx, input) do |date, val, i|
		if current_date.nil? # init
			current_date = date
		elsif date < current_date # find min
			current_date = date
		end
	end

	# update vals for each minimum date
	each_current_date(current_idx, input) do |date, val, i|
		if date == current_date
			current[i] = val
			current_idx[i] += 1
		end
	end

	break if current_date.nil?

	# output sums
	tmp = 0
	printf("%d", current_date)
	current.each do |val|
		tmp += val
		printf("\t%d", tmp)
	end
	puts
end
