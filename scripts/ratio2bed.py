import sys

# Check if enough arguments are provided
if len(sys.argv) < 3:
    print("Usage: python script.py <input_file> <output_file>")
    sys.exit(1)

# Input and output file paths from command line arguments
input_file_path = sys.argv[1]
output_file_path = sys.argv[2] + ".filter.bed"

# Initialize an empty dictionary to store results if needed later
save_dict = {}

# Process the input file and generate the output
with open(input_file_path, 'r') as file, open(output_file_path, 'w') as output:
    for line in file:
        line = line.strip()  # Remove any trailing newline characters
        elements = line.split()
        
        # Extract chromosome name and identifier
        name, chro = elements[0].split("|")
        
        # Process each position data block
        for pos in elements[1:]:
            pos_details = pos.split("|")
            pos1 = int(pos_details[0])
            coverage1 = pos_details[1]
            coverage2 = pos_details[2]
            ratio = float(pos_details[3])  # Assuming ratio is a float

            # Apply conditions to filter the data
            if ratio >= 0 and int(coverage2) > 5:  # Ensure coverage2 is an integer for comparison
                entry = (f"{chro}_{str(pos1)}", str(pos1), str(pos1 + 1), str(ratio), name, coverage1, coverage2)
                output.write("\t".join(entry) + "\n")

# Commenting out dictionary usage since it's not applied in this snippet
# save_dict[f"{chro}|{pos1}|{name}"] = 1

# The output file is automatically closed when exiting the with block

