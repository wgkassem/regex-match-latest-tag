package Search;
sub find_last {
# Specify the file name and patterns
  my ($regex, $filename) = @_;
  my $last_match = "";

  # compule regex
  my $pattern = qr/$regex/;

  # Open the file for reading
  open my $file, '<', $filename or return $last_match;

  # Loop through each line in the file
  while (<$file>) {
      # Check if the line matches the pattern
      if ($_ =~ /$pattern/) {
          # Print the matching line
          $last_match = $_;
          # string trailing newline
          chomp $last_match;
      }
  }

  # Close the file
  close $file;

  return $last_match;
}

# if the file is being executed directly from the command line (not loaded as a module)
# then run the find_last function

if (!caller) {
  my $regex = shift @ARGV;
  my $filename = shift @ARGV;
  my $last_match = find_last($regex, $filename);
  print "$last_match\n";
}

1;
