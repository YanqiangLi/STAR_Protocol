import pandas as pd
import argparse

# Set up argument parser
parser = argparse.ArgumentParser(description="Merge two files based on the common ID.")
parser.add_argument("file1", help="Path to the first input file.")
parser.add_argument("file2", help="Path to the second input file.")
parser.add_argument("output_file", help="Path to the output file.")

# Parse arguments
args = parser.parse_args()

# Load the first file
df1 = pd.read_csv(args.file1, sep="\t", header=None, names=["ID", "Column2", "Column3", "Column4", "Column5", "Column6"])

# Load the second file
df2 = pd.read_csv(args.file2, sep="\t", header=None, names=["ID", "Column2_2", "Column3_2", "Column4_2", "Column5_2", "Column6_2"])

# Perform an inner merge to retain only rows with common IDs
merged_df = pd.merge(df1, df2, on="ID", how="inner")

# Save the merged DataFrame to a file
merged_df.to_csv(args.output_file, sep="\t", index=False, header=False)

print(f"Merged file saved to {args.output_file}")

