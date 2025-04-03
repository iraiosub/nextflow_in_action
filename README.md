
# Nextflow in Action 🚀
## Design and Implement Your Own Bioinformatics Workflows

This workshop provides an introduction to bioinformatics workflow managers, with a focus on Nextflow. Participants will gain an understanding of workflow management concepts and learn how to use Nextflow to develop scalable, reproducible, and portable bioinformatics pipelines. The session will include an overview of key features, practical examples, and guidance on best practices for implementing workflows in a research context. The workshop is designed for those interested in improving the efficiency and reproducibility of their computational biology analyses.



## Prerequisites

We assume some minimal exposure to GitHub and Nextflow. To get the most out of the workshop we would recommend participants look over the following training material beforehand:

- Software Carpentry's [Git training](https://swcarpentry.github.io/git-novice/)
- Seqera's ["Hello Nextflow" training](https://training.nextflow.io/latest/hello_nextflow/)

In terms of software/hardware requirements, everything can be run locally on your laptop or on HPC as you prefer. You will need Nextflow and nf-core tools installed and a container engine such as Docker or Singularity.

## Learning Outcomes
In this workshop you will learn:
- How to compose a bioinformatics workflow in Nextflow using a combination of writing your own modules and utilising the incredible [nf-core modules](https://nf-co.re/modules/) resource.
- How to manipulate channels to move data through your workflow like a pro.
- How to implement logic switches in your pipeline.
- How to implement unit tests with [nf-test](https://www.nf-test.com/).
- An appreciation of when writing a workflow might be a good idea, and how layers of additional complexity can make your workflow more flexible and robust.

## Getting Started

Everything you need is in the `docs/Lecture.html` slides on the `main` branch. The lecture walks you through a series of tasks to build a toy pipeline. The solutions to the tasks are in sequentially numbered branches.

## Getting the Most Out of the Workshop

The best way to make the most of the workshop is to fork this repo and clone it locally. This way, you can follow along and code on your own copy.

### Steps:
1. **Fork the Repository**:
   - Navigate to the repo on GitHub and click the **Fork** button in the top-right corner to create a copy in your GitHub account.

2. **Clone the Repository Locally**:
   - Go to your forked repo and click the **Code** button.
   - Copy the URL under "Clone with HTTPS".
   - In your terminal, run:
     ```bash
     git clone https://github.com/YOUR_USERNAME/nextflow_in_action.git
     ```
     Replace `YOUR_USERNAME` with your GitHub username.

3. **Navigate to the Repo**:
   - Once cloned, go into the repo directory:
     ```bash
     cd nextflow_in_action
     ```

4. **Switch branches as needed**:
   - To see what brach you're on:
     ```bash
     git status
     ```
   - To switch to a specific branch:
     ```bash
     git checkout 1
     ```

## Independent Study

The materials in this repo are great for independent study. The lecture slides are on the main branch and outline exercises 1-7. Each corresponding branch (1-7) contains the solution code for that exercise.

It's best to attempt the exercises first, then refer to the solutions if needed. You can also explore the [Nextflow](https://nextflow.io/docs/latest/index.html) and [nf-core](https://nf-co.re/docs/nf-core-tools) docs and training at [Nextflow Training](https://training.nextflow.io) for extra help.

Start with Branch 1, which contains the skeleton for a mini-pipeline, and progress through the tasks as they gradually increase in complexity.



## Authors

- [Ira Iosub, PhD](https://www.github.com/iraiosub) ira.iosub@crick.ac.uk
- [Charlotte Capitanchik, PhD](https://www.github.com/charlotteanne42) charlotte.capitanchik@kcl.ac.uk


## License

[MIT](https://choosealicense.com/licenses/mit/)

We'd love to hear if you implement our workshop and how it went! Drop us an email to tell us about it.

If you notice any mistakes, or would like to make a contribution please feel free to open an issue.
