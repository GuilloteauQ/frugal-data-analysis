use polars::prelude::*;

fn main() -> Result<(), PolarsError>{
    let args: Vec<String> = std::env::args().collect();
    assert!(args.len() == 3);
    let infilename = &args[1];
    let outfilename = &args[2];

    let mut outfile = std::fs::File::create(outfilename).unwrap();
    let mut df = LazyCsvReader::new(infilename)
        .finish()?
        .group_by([col("cluster_name"), col("project")])
        .agg([
           col("duration").mean(),
           col("job_id").count()
        ])
        .collect()?;
    CsvWriter::new(&mut outfile)
        .finish(&mut df)?;
    Ok(())
}
