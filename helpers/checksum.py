import hashlib

def generate_checksum(file_path, hash_algorithm="sha256"):
    # Create a hash object based on the specified algorithm
    hash_func = hashlib.new(hash_algorithm)

    # Open the file in binary mode and read in chunks to avoid memory overload
    with open(file_path, 'rb') as f:
        while chunk := f.read(8192):  # Read file in 8KB chunks
            hash_func.update(chunk)

    # Return the checksum (digest) in hexadecimal format
    return hash_func.hexdigest()

# Example usage
file_path = "agama.py"  # Replace with your file path
checksum = generate_checksum(file_path, "sha256")
print(f"SHA256 Checksum: {checksum}")