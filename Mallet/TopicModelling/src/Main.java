import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StreamTokenizer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Random;


public class Main {

	static KeywordExtractor kwe;
	static HashMap<String, Long> javaKeys;

	public static void init(String s)
	{
		kwe = KeywordExtractor.getInstance();
		javaKeys = new HashMap<String, Long>();

		try{
			File f = new File(s);
			BufferedReader br = new BufferedReader(new FileReader(f));
			String key;
			while((key=br.readLine())!=null){
				javaKeys.put(key.trim(),new Long(0));
			}
			br.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	// This function returns false if the token is a Java keyword or stopword
	// Else it returns true so that the token is retained
	static boolean categorize(String s){
		// Split current token, if need be
		ArrayList al = kwe.processCode(s);
		Iterator it = al.iterator();
		// For each split part, check if it is a java keyword, etc.
		while(it.hasNext()){
			String ss = (String) it.next();
			if(s!=null && !javaKeys.containsKey(ss) && ss.indexOf('.')==-1){
				if (!ss.matches("\\d*"))
					return true;
			}
		}
		return false;
	}

	// This function recurses into the source directory containing .java source files
	// It tokenizes each .java file, removes comments,
	public static void recurse(String baseDir, String mirrorDir) throws IOException, InterruptedException
	{
		// Initialize a stream tokenizers

		File dir = new File(baseDir);
		String[] files = dir.list();

		for (String file : files) {
			// If the file is a subdirectory, recurse
			if (new File(baseDir + "/" + file).isDirectory())
				recurse(baseDir + "/" + file, mirrorDir + "/" + file);
			else {
				// Check if file ends in .java and if it does, tokenize it
				if (file.endsWith(".java") == false)
					continue;
				// Initialize a stream tokenizer
				FileReader rd = new FileReader(baseDir + "/" + file);
				StreamTokenizer st = new StreamTokenizer(rd);

				// Prepare the tokenizer for Java-style tokenizing rules
				st.parseNumbers();
				st.wordChars('_', '_');
				st.eolIsSignificant(true);

				// Discard comments
				st.slashSlashComments(true);
				st.slashStarComments(true);

				// Parse file
				int token = st.nextToken();
				String content = "";
				String previous = "";
				while (token != StreamTokenizer.TT_EOF) {
					switch (token) {
					
					case StreamTokenizer.TT_WORD:
						// Check if it is a package name from package import statement
						if (previous.compareTo("package") == 0 || previous.compareTo("import") == 0) {
							String[] fields = st.sval.split("\\.");
							for (int i=0; i<fields.length; i++) {
								previous = fields[i];
								if (categorize(fields[i]))
									content += fields[i] + " ";
							}
							break;
						}
						previous = st.sval;
						// Check if the word a stopword, java keyword, etc.
						// If not, append it to the content to be written back
						if (categorize(st.sval))
							content += st.sval.toLowerCase() + " ";
						break;
						
					case StreamTokenizer.TT_NUMBER:
						// Check for numbers, decimal and hexadecimal
						if ((token = st.nextToken()) != StreamTokenizer.TT_EOF) {
							if (token == StreamTokenizer.TT_WORD && st.sval.startsWith("x"))
								;
							else
								st.pushBack();
						}
						else
							st.pushBack();
						break;
						
					default:
						// Ignore every other case
						break;
					}
					token = st.nextToken();
				}
				rd.close();

				// Write content to the file
				if (content.length() != 0) {
					File newDir = new File(mirrorDir);
					if (newDir.exists() == false)
						newDir.mkdirs();
					FileWriter wt = null;
					wt = new FileWriter(mirrorDir + "/" + file);

					wt.write(content);
					wt.close();
				}
			}
		}
	}

	public static void main(String[] argv) throws IOException, InterruptedException
	{
		init("keywords");
		// argv[0] is the base directory where data directory sits
		// Recurse through the directories
		// Whenever we find a .java file, we tokenize it and write
		// it down in corresponding mirrored directoy
		String dataDir = argv[0] + "/data";
		String mirrorDir = argv[0] + "/mallet-data";

		// A sample snapshot of the data directory is as following
		// ├── thrift
		// │   ├── thrift-0.6.0
		// │   ├── thrift-0.7.0
		// │   └── thrift-0.8.0
		// ├── tomcat
		// │   ├── apache-tomcat-5.5.12
		// │   ├── apache-tomcat-6.0.0
		// │   ├── apache-tomcat-7.0.10
		// │   ├── jakarta-tomcat-3.3.1
		// │   ├── jakarta-tomcat-4.1.27
		// │   └── jakarta-tomcat-5.0.28
		// └── xerces
		//     ├── xerces-2_10_0
		//     ├── xerces-2_11_0
		//     └── xerces-2_9_1
		
		// The individual directories contain source code obtained from the respective
		// websites

		// Mirror directory structure while retaining only tokenized .java source files
		recurse(dataDir, mirrorDir);
	}
}
