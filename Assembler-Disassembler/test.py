#!/home/albert/mambaforge/bin/python
import os
import subprocess

def main(dirname=None):
    # Find all directories containing this script
    script_dir = os.path.dirname(os.path.abspath(__file__))
    dirs = [d for d in os.listdir(script_dir) if os.path.isdir(d)]
    
    if dirname is not None:
        dirs = [dirname]

    # Loop over each directory and run the script
    for dirname in dirs:
        dirname = dirname.strip() # Remove leading/trailing white space
        print(f"Processing directory: {dirname}")
        try:
            subprocess.run(["./Assemble.py", f"{dirname}/{dirname}.txt", f"{dirname}/{dirname}.asm"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["./Decode.py", f"{dirname}/{dirname}.asm", f"{dirname}/{dirname}_dec.txt"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            subprocess.run(["./Assemble.py", f"{dirname}/{dirname}_dec.txt", f"{dirname}/{dirname}_asm.asm"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            
            if dirname != "All_instructions":
                # Check the diff between the original and final text files
                diff1 = subprocess.run(["diff", f"{dirname}/{dirname}.txt", f"{dirname}/{dirname}_dec.txt"], capture_output=True, text=True)
                if diff1.stdout:
                    print("\033[91m" + f"Differences between {dirname}.txt and {dirname}_dec.txt:" + "\033[0m")
                    print(diff1.stdout)
                else:
                    print("\033[92m" + f"No differences found between {dirname}.txt and {dirname}_dec.txt." + "\033[0m")
                # Check the diff between the original and final assembly files
                diff2 = subprocess.run(["diff", f"{dirname}/{dirname}.asm", f"{dirname}/{dirname}_asm.asm"], capture_output=True, text=True)
                if diff2.stdout:
                    print("\033[91m" + f"Differences between {dirname}.asm and {dirname}_asm.asm:" + "\033[0m")
                    print(diff2.stdout)
                else:
                    print("\033[92m" + f"No differences found between {dirname}.asm and {dirname}_asm.asm." + "\033[0m")
            
        except subprocess.CalledProcessError as e:
            print(f"An error occurred while processing directory {dirname}: {e}")
        print() # Add an empty line between directories

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        dirname = sys.argv[1]
        main(dirname)
    else:
        main()
