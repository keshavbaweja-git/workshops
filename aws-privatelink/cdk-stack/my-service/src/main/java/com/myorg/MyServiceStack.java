package com.myorg;

import software.amazon.awscdk.Stack;
import software.amazon.awscdk.StackProps;
import software.amazon.awscdk.services.ecs.ContainerImage;
import software.amazon.awscdk.services.ecs.patterns.NetworkLoadBalancedFargateService;
import software.amazon.awscdk.services.ecs.patterns.NetworkLoadBalancedTaskImageOptions;
import software.constructs.Construct;

public class MyServiceStack extends Stack {
    public MyServiceStack(final Construct scope, final String id) {
        this(scope,
             id,
             null);
    }

    public MyServiceStack(final Construct scope, final String id, final StackProps props) {
        super(scope,
              id,
              props);

        final NetworkLoadBalancedFargateService loadBalancedFargateService = NetworkLoadBalancedFargateService.Builder.create(this,
                                                                                                                              "Service")
                                                                                                                      .memoryLimitMiB(1024)
                                                                                                                      .cpu(512)
                                                                                                                      .taskImageOptions(NetworkLoadBalancedTaskImageOptions.builder()
                                                                                                                                                                           .image(ContainerImage.fromRegistry("amazon/amazon-ecs-sample"))
                                                                                                                                                                           .build())
                                                                                                                      .publicLoadBalancer(false)
                                                                                                                      .build();
    }
}
