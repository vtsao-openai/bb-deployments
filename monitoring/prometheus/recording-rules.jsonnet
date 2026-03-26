{
  groups: [
    {
      name: 'recording_rules',
      rules: [
        // Take the existing blob size and batch size metrics and
        // turn them into a single aggregated metric per operation.
        {
          expr: 'sum(irate(buildbarn_blobstore_blob_access_operations_blob_size_bytes_count{}[5m])) by (cluster, namespace, backend_type, app, operation, storage_type)',
          record: 'backend_type_kubernetes_service_operation_storage_type:buildbarn_blobstore_blob_access_operations_started:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_blobstore_blob_access_operations_find_missing_batch_size_count{}[5m])) by (cluster, namespace, backend_type, app, storage_type)',
          labels: {
            operation: 'FindMissing',
          },
          record: 'backend_type_kubernetes_service_operation_storage_type:buildbarn_blobstore_blob_access_operations_started:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_blobstore_blob_access_operations_duration_seconds_bucket{}[5m])) by (cluster, namespace, backend_type, app, le, operation, storage_type)',
          record: 'backend_type_kubernetes_service_le_operation_storage_type:buildbarn_blobstore_blob_access_operations_duration_seconds_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_blobstore_blob_access_operations_duration_seconds_count{}[5m])) by (cluster, namespace, backend_type, grpc_code, app, storage_type)',
          record: 'backend_type_grpc_code_kubernetes_service_storage_type:buildbarn_blobstore_blob_access_operations_duration_seconds_count:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_blobstore_blob_access_operations_find_missing_batch_size_bucket{}[5m])) by (cluster, namespace, backend_type, app, le, storage_type)',
          record: 'backend_type_kubernetes_service_le_storage_type:buildbarn_blobstore_blob_access_operations_find_missing_batch_size_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_blobstore_blob_access_operations_blob_size_bytes_bucket{}[5m])) by (cluster, namespace, backend_type, app, le, operation, storage_type)',
          record: 'backend_type_kubernetes_service_le_operation_storage_type:buildbarn_blobstore_blob_access_operations_blob_size_bytes_bucket:irate1m',
        },

        // Statistics on retention of centralized storage.
        {
          expr: 'sum(irate(buildbarn_blobstore_hashing_key_location_map_get_attempts_count{app="storage"}[5m])) by (cluster, namespace, storage_type, outcome)',
          record: 'outcome_storage_type:buildbarn_blobstore_hashing_key_location_map_get_attempts_count:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_blobstore_hashing_key_location_map_get_too_many_attempts_total{app="storage"}[5m])) by (cluster, namespace, storage_type)',
          record: 'storage_type:buildbarn_blobstore_hashing_key_location_map_get_too_many_attempts:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_blobstore_hashing_key_location_map_get_attempts_bucket{app="storage"}[5m])) by (cluster, namespace, le, storage_type)',
          record: 'le_storage_type:buildbarn_blobstore_hashing_key_location_map_get_attempts_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_blobstore_hashing_key_location_map_put_ignored_invalid_total{app="storage"}[5m])) by (cluster, namespace, storage_type)',
          record: 'storage_type:buildbarn_blobstore_hashing_key_location_map_put_ignored_invalid:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_blobstore_hashing_key_location_map_put_iterations_count{app="storage"}[5m])) by (cluster, namespace, outcome, storage_type)',
          record: 'outcome_storage_type:buildbarn_blobstore_hashing_key_location_map_put_iterations_count:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_blobstore_hashing_key_location_map_put_too_many_iterations_total{app="storage"}[5m])) by (cluster, namespace, storage_type)',
          record: 'storage_type:buildbarn_blobstore_hashing_key_location_map_put_too_many_iterations:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_blobstore_hashing_key_location_map_put_iterations_bucket{app="storage"}[5m])) by (cluster, namespace, le, storage_type)',
          record: 'le_storage_type:buildbarn_blobstore_hashing_key_location_map_put_iterations_bucket:irate1m',
        },

        // Rate at which tasks are processed by the scheduler.
        {
          expr: 'sum(irate(buildbarn_builder_in_memory_build_queue_tasks_scheduled_total{app="scheduler"}[5m])) by (cluster, namespace, instance_name_prefix, platform, size_class)',
          record: 'instance_name_prefix_platform_size_class:buildbarn_builder_in_memory_build_queue_tasks_queued:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_in_memory_build_queue_tasks_queued_duration_seconds_count{app="scheduler"}[5m])) by (cluster, namespace, instance_name_prefix, platform, size_class)',
          record: 'instance_name_prefix_platform_size_class:buildbarn_builder_in_memory_build_queue_tasks_executing:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_in_memory_build_queue_tasks_executing_duration_seconds_count{app="scheduler"}[5m])) by (cluster, namespace, grpc_code, instance_name_prefix, platform, result, size_class)',
          record: 'grpc_code_instance_name_prefix_platform_result_size_class:buildbarn_builder_in_memory_build_queue_tasks_completed:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_in_memory_build_queue_tasks_completed_duration_seconds_count{app="scheduler"}[5m])) by (cluster, namespace, instance_name_prefix, platform, size_class)',
          record: 'instance_name_prefix_platform_size_class:buildbarn_builder_in_memory_build_queue_tasks_removed:irate1m',
        },

        // Subtract counters of consecutive scheduler stages to derive
        // how many tasks are in each of the stages.
        {
          expr: |||

            sum(buildbarn_builder_in_memory_build_queue_tasks_scheduled_total{app="scheduler"}) by (cluster, namespace, instance_name_prefix, platform, size_class)
            -
            sum(buildbarn_builder_in_memory_build_queue_tasks_queued_duration_seconds_count{app="scheduler"}) by (cluster, namespace, instance_name_prefix, platform, size_class)
          |||,
          record: 'instance_name_prefix_platform_size_class:buildbarn_builder_in_memory_build_queue_tasks_queued:sum',
        },
        {
          expr: |||

            sum(buildbarn_builder_in_memory_build_queue_tasks_queued_duration_seconds_count{app="scheduler"}) by (cluster, namespace, instance_name_prefix, platform, size_class)
            -
            sum(buildbarn_builder_in_memory_build_queue_tasks_executing_duration_seconds_count{app="scheduler"}) by (cluster, namespace, instance_name_prefix, platform, size_class)
          |||,
          record: 'instance_name_prefix_platform_size_class:buildbarn_builder_in_memory_build_queue_tasks_executing:sum',
        },
        {
          expr: |||
            sum(buildbarn_builder_in_memory_build_queue_tasks_executing_duration_seconds_count{app="scheduler"}) by (cluster, namespace, instance_name_prefix, platform, size_class)
            -
            sum(buildbarn_builder_in_memory_build_queue_tasks_completed_duration_seconds_count{app="scheduler"}) by (cluster, namespace, instance_name_prefix, platform, size_class)
          |||,
          record: 'instance_name_prefix_platform_size_class:buildbarn_builder_in_memory_build_queue_tasks_completed:sum',
        },

        // Duration of how long tasks remain in scheduler stages.

        {
          expr: 'sum(irate(buildbarn_builder_in_memory_build_queue_tasks_queued_duration_seconds_bucket{app="scheduler"}[5m])) by (cluster, namespace, instance_name_prefix, le, platform, size_class)',
          record: 'instance_name_prefix_le_platform_size_class:buildbarn_builder_in_memory_build_queue_tasks_queued_duration_seconds_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_in_memory_build_queue_tasks_executing_duration_seconds_bucket{app="scheduler"}[5m])) by (cluster, namespace, instance_name_prefix, le, platform, size_class)',
          record: 'instance_name_prefix_le_platform_size_class:buildbarn_builder_in_memory_build_queue_tasks_executing_duration_seconds_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_in_memory_build_queue_tasks_completed_duration_seconds_bucket{app="scheduler"}[5m])) by (cluster, namespace, instance_name_prefix, le, platform, size_class)',
          record: 'instance_name_prefix_le_platform_size_class:buildbarn_builder_in_memory_build_queue_tasks_completed_duration_seconds_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_in_memory_build_queue_tasks_executing_retries_bucket{app="scheduler"}[5m])) by (cluster, namespace, instance_name_prefix, le, platform, size_class)',
          record: 'instance_name_prefix_le_platform_size_class:buildbarn_builder_in_memory_build_queue_tasks_executing_retries_bucket:irate1m',
        },

        // Recording rules used by the "BuildExecutor" dashboard.
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_duration_seconds_count{}[5m])) by (cluster, namespace, app)',
          record: 'kubernetes_service:buildbarn_builder_build_executor_operations:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_duration_seconds_bucket{}[5m])) by (cluster, namespace, app, le, stage)',
          record: 'kubernetes_service_le_stage:buildbarn_builder_build_executor_duration_seconds_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_virtual_execution_duration_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_virtual_execution_duration_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_user_time_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_user_time_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_system_time_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_system_time_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_maximum_resident_set_size_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_maximum_resident_set_size_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_page_reclaims_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_page_reclaims_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_page_faults_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_page_faults_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_swaps_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_swaps_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_block_input_operations_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_block_input_operations_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_block_output_operations_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_block_output_operations_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_messages_sent_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_messages_sent_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_messages_received_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_messages_received_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_signals_received_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_signals_received_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_voluntary_context_switches_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_voluntary_context_switches_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_posix_involuntary_context_switches_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_posix_involuntary_context_switches_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_file_pool_files_created_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_file_pool_files_created_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_file_pool_files_count_peak_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_file_pool_files_count_peak_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_file_pool_files_size_bytes_peak_bucket{}[5m])) by (cluster, namespace, app, le)',
          record: 'kubernetes_service_le:buildbarn_builder_build_executor_file_pool_files_size_bytes_peak_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_file_pool_operations_count_bucket{}[5m])) by (cluster, namespace, app, le, operation)',
          record: 'kubernetes_service_le_operation:buildbarn_builder_build_executor_file_pool_operations_count_bucket:irate1m',
        },
        {
          expr: 'sum(irate(buildbarn_builder_build_executor_file_pool_operations_size_bytes_bucket{}[5m])) by (cluster, namespace, app, le, operation)',
          record: 'kubernetes_service_le_operation:buildbarn_builder_build_executor_file_pool_operations_size_bytes_bucket:irate1m',
        },

        // Recording rules for the "Eviction sets" dashboard.
        {
          expr: 'sum(rate(buildbarn_eviction_set_operations_total{}[1h])) by (cluster, namespace, app, name, operation)',
          record: 'kubernetes_service_name_operation:buildbarn_eviction_set_operations:rate1h',
        },

        // Recording rules used by the 'gRPC clients' dashboard.
        {
          expr: |||
            sum(
              grpc_client_started_total{}
              -
              sum(grpc_client_handled_total{}) without (grpc_code)
            ) by (cluster, namespace, grpc_method, grpc_service, app)
          |||,
          record: 'grpc_method_grpc_service_kubernetes_service:grpc_client_in_flight:sum',
        },
        {
          expr: 'sum(irate(grpc_client_handled_total{}[5m])) by (cluster, namespace, grpc_code, grpc_method, grpc_service, app)',
          record: 'grpc_code_grpc_method_grpc_service_kubernetes_service:grpc_client_handled:irate1m',
        },
        {
          expr: 'sum(irate(grpc_client_msg_sent_total{}[5m])) by (cluster, namespace, grpc_method, grpc_service, app)',
          record: 'grpc_method_grpc_service_kubernetes_service:grpc_client_msg_sent:irate1m',
        },
        {
          expr: 'sum(irate(grpc_client_msg_received_total{}[5m])) by (cluster, namespace, grpc_method, grpc_service, app)',
          record: 'grpc_method_grpc_service_kubernetes_service:grpc_client_msg_received:irate1m',
        },
        {
          expr: 'sum(irate(grpc_client_handling_seconds_bucket{}[5m])) by (cluster, namespace, grpc_method, grpc_service, app, le)',
          record: 'grpc_method_grpc_service_kubernetes_service_le:grpc_client_handling_seconds_bucket:irate1m',
        },

        // Recording rules used by the 'gRPC servers' dashboard.
        {
          expr: |||
            sum(
              grpc_server_started_total{}
              -
              sum(grpc_server_handled_total{}) without (grpc_code)
            ) by (cluster, namespace, grpc_method, grpc_service, app)
          |||,
          record: 'grpc_method_grpc_service_kubernetes_service:grpc_server_in_flight:sum',
        },
        {
          expr: 'sum(irate(grpc_server_handled_total{}[5m])) by (cluster, namespace, grpc_method, grpc_service, app)',
          record: 'grpc_method_grpc_service_kubernetes_service:grpc_server_handled:irate1m',
        },
        {
          expr: 'sum(irate(grpc_server_handled_total{}[5m])) by (cluster, namespace, grpc_code, grpc_method, grpc_service, app)',
          record: 'grpc_code_grpc_method_grpc_service_kubernetes_service:grpc_server_handled:irate1m',
        },
        {
          expr: 'sum(irate(grpc_server_msg_sent_total{}[5m])) by (cluster, namespace, grpc_method, grpc_service, app)',
          record: 'grpc_method_grpc_service_kubernetes_service:grpc_server_msg_sent:irate1m',
        },
        {
          expr: 'sum(irate(grpc_server_msg_received_total{}[5m])) by (cluster, namespace, grpc_method, grpc_service, app)',
          record: 'grpc_method_grpc_service_kubernetes_service:grpc_server_msg_received:irate1m',
        },
        {
          expr: 'sum(irate(grpc_server_handling_seconds_bucket{}[5m])) by (cluster, namespace, grpc_method, grpc_service, app, le)',
          record: 'grpc_method_grpc_service_kubernetes_service_le:grpc_server_handling_seconds_bucket:irate1m',
        },
      ],
    },
  ],
}
