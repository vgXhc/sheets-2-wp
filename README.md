# sheets-2-wp
For the 2023 municipal spring primary and general elections in Madison, Madison Bikes, Madison is for People, and Madison Area Bus Advocates sent questionnaires to all candidates for mayor and common council. Candidates responded on two different Google Forms. The code in this repository takes those responses and transforms them into a nicely formatted HTML and pdf document. The name of the repo comes from the fact that the initial goal was to also automatically publish the content via API to WordPress, but that didn't work out.

Knitting the `combine-report.Rmd` file produces the output. The two files `output_council_child.Rmd` and  `output_mayor_child.Rmd` provide the templates used within `combine-report` file for each of the candidates. Once the `html` has been generated, its content is pasted into a custom html block on WordPress. The code is very specific to the two forms at this point.

You can see the result here: https://www.madisonbikes.org/madison-spring-elections-2023/
