
module load tools/env/proxy
module load apps/bowtie2/2.3.0/gcc-4.8.5
module load apps/samtools/1.9/gcc-4.8.5


module search



# 1
grep ">.*\/1$" MarRef.genustrain.fasta | tr -d ">" | cut -d "/" -f1 | cut -d "|" -f3 | cut -d "-" -f1 | sort | uniq >MarRef.genomeID

# 2 
for i in `cat MarRef.genomeID`
do
#echo "$i"
echo "${i%_*}"
b=${i%_*}
grep -A 1 "$b" MarRef.genustrain.fasta >"$b".interleaved.fasta
grep -A 1 "1$" "$b".interleaved.fasta >"$b".R1.fa
grep -A 1 "2$" "$b".interleaved.fasta >"$b".R2.fa
done

# 3
remove anything with _1, _2, _3, _4. 

# 4
MIN_COVERAGE_DEPTH=1
for b in `cat MarRef.genomeID`
#for i in `cat FF.genomeID`
do
i=${b%_*}
echo "$i" >> output_depth_1.txt

# map short reads against reference genome
# create bowtie2 index database (database name: refgenome)
bowtie2-build "$i".NR.fa "$i"

# get breadth of coverage
bowtie2 -p 12 -f -x "$i" --no-unal -1 "$i".R1.fa -2 "$i".R2.fa -S "$i".sam
samtools view -F4 -bS "$i".sam > "$i".bam
samtools sort -m 5G -o "$i".sorted.bam "$i".bam

# create samtools index
samtools index "$i".sorted.bam

# get total number of bases covered at MIN_COVERAGE_DEPTH or higher
samtools mpileup "$i".sorted.bam | awk -v X="${MIN_COVERAGE_DEPTH}" '$4>=X' | wc -l >> output_depth_1_cov.txt

# get length of reference genome
bowtie2-inspect -s "$i" | awk '{ FS = "\t" } ; BEGIN{L=0}; {L=L+$3}; END{print L}' >> output_depth_1_ref.txt
done


for i in `cat FF.genomeID`
do
echo "$i"
grep -A 1 "$i" MarRef.genustrain.fasta >"$i".interleaved.fasta
grep -A 1 "1$" "$i".interleaved.fasta >"$i".R1.fa
grep -A 1 "2$" "$i".interleaved.fasta >"$i".R2.fa
done

