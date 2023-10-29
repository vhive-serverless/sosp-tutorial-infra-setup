# MIT License
#
# Copyright (c) 2023 Dilina Dehigama and EASE Lab
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import csv

# Read the CSV file with IP addresses
input_file = 'ips.csv'  # Replace with your input file name
output_file = 'ip_allocation.csv' 

# Generate unique pairs of IP:port
unique_pairs = []
ips = []
with open(input_file, 'r') as ip_file:
    reader = csv.reader(ip_file)
    for row in reader:
        ips.append(row[0])

for port in range(1, 6):
    for ip in ips:
        unique_pairs.append(ip + ":" + str(port))

# Write the unique IP:port pairs to a new CSV file
with open(output_file, 'w', newline='') as outputf:
    outputf.write('IP,User_Email\n')
    for pair in unique_pairs:
        outputf.write(pair+"\n")

print(f'Unique IP:port pairs saved to {output_file}')
