import pandas as pd
import argparse

# Set up argument parser
parser = argparse.ArgumentParser(description="Merge three files based on the common ID.")
parser.add_argument("first_file", help="Path to the first input file (human.rRNA.Nm.bed).")
parser.add_argument("second_file", help="Path to the second input file (siCTRL_rRNA.filter.bed).")
parser.add_argument("third_file", help="Path to the third input file (siFBL_rRNA.filter.bed).")
parser.add_argument("output_file", help="Path to the output file.")

# Parse arguments
args = parser.parse_args()

# Load the first file
first_file = pd.read_csv(args.first_file, sep="\t", header=None, names=["ID", "Position", "Name", "Score", "Strand"])

# Load the second and third files
second_file = pd.read_csv(args.second_file, sep="\t", header=None, names=["ID", "Start", "Value1", "Type", "Range1", "Range2"])
third_file = pd.read_csv(args.third_file, sep="\t", header=None, names=["ID", "Start", "End", "Value2", "Type", "Range3", "Range4"])

# Merge the data based on the common ID
merged = first_file.merge(second_file, on="ID", how="inner").merge(third_file, on="ID", how="left")

# Save the output
merged.to_csv(args.output_file, sep="\t", index=False, header=False)

print(f"Merged file created: {args.output_file}")

