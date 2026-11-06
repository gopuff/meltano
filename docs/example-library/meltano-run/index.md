# Get setup

This examples shows to how to get up and running using `meltano run` with `tap-gitlab` and `target-postgres`.
To get started with this example download the [meltano yml](/docs/example-library/meltano-run/meltano.yml) to a fresh directory and run:

```shell
meltano install
```

## Configure an extractor

The installed meltano.yml already includes a configured instance of the `tap-gitlab` extractor for this example. You can view
the configuration of the extractor by running:

```shell !
meltano config tap-gitlab list
```

## Configure a loader

Next we'll need to configure a loader to store our gitlab data. We'll use [`target-postgres`](https://hub.meltano.com/loaders/target-postgres)
which was installed by the `meltano install` command but may require tweaking of the configuration to match your environment:

```shell
meltano --environment=dev config target-postgres set user postgres
meltano --environment=dev config target-postgres set password postgres
meltano --environment=dev config target-postgres set dbname warehouse
meltano --environment=dev config target-postgres set default_target_schema public
```

Note that sensitive config options such as `password` [aren't stored in your `meltano.yml` but in `.env` instead](https://docs.meltano.com/guide/configuration#configuration-layers). Print out the config to make sure it looks as expected:
## Performing work

We're ready to start getting some work done! Go ahead and run your EL task using `meltano run`:

```shell
meltano run tap-gitlab target-postgres
```

You'll get quite a bit of output, two key lines near the end of the output that you should see are:

```
<timestamps> [info     ] Incremental state has been updated at <timestamp>.
<timestamps> [info     ] Block run completed.           block_type=ExtractLoadBlocks err=None set_number=0 success=True
```

### Adding a job

Lets go ahead add a `job` for this that we can reference directly:

```shell
meltano job add gitlab-to-postgres --tasks "tap-gitlab target-postgres"
```

You can reference jobs in `meltano run` invocations directly:

```shell !
meltano run --dry-run gitlab-to-postgres
```

# Pulling it all together

```shell
meltano run gitlab-to-postgres
```
