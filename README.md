# Inmuniversia

Inmuniversia is an open source platform for providing information on vaccines and the diseases they prevent, and subscribing to vaccination reminders. Developed by InSTEDD.

Uses Ruby 1.9.3 and Rails 3.2.13.

# Configuration

The project uses Capistrano for installation, and will automatically link files `settings.yml` and `database.yml` from the `shared` folder. Refer to the `config/settings.yml` file to override any settings as needed.

## Nuntium

Inmuniversia uses [Nuntium](http://bitbucket.org/instedd/nuntium) for delivering SMS notifications. Please set up your account and an SMS channel in Nuntium and enter the necessary information in `settings.yml`.

## Vaccine and Disease information

Inmuniversia uses [Refinery CMS](http://refinerycms.com) as a back end for editing vaccine and disease information. Navigate to `/refinery` as the server is set up to edit the information as needed. The application will automatically set up an `admin@example.com` user with password `ChangeMe` to access the CMS back end.

## Official calendar

The rake task `calendar:load` will load doses information for the vaccines in the 2013 Argentinian official vaccinations calendar.

# Contributing and Help

Please refer to the [InTEDD Tech](http://groups.google.com/group/instedd-tech) discussion group for any questions. Contact us there if you want to contribute to the project.

## Coding Style

Soft tabs with 2 spaces and UNIX-like carriage returns. Please set up your text editor to follow this guideline.

## Licensing

This project is licensed under GPLv3.