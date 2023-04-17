// compile to lambda: GOARCH=amd64 GOOS=linux go build main.go
package main

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
	//	"github.com/aws/aws-lambda-go/lambdacontext"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ecs"
)

const TARGET_CLUSTER = "ecs-on-fargate"

type LogLevel string

const (
	DEBUG LogLevel = "DEBUG"
	INFO  LogLevel = "INFO"
	WARN  LogLevel = "WARN"
	ERROR LogLevel = "ERROR"
)

const (
	INVALID       int32 = -1
	SERVICE_START int32 = 1
	SERVICE_STOP  int32 = 0
)

// エラーフォーマット：yyyy-mm-dd HH:MM:SS [Level] message
func Logger(logLevel LogLevel, message interface{}) {
	nowTime := time.Now().Format("2006-01-02 15:04:05")
	fmt.Printf("%s [%s] %v\n", nowTime, logLevel, message)
}

func EcsTaskHander(desired int32) {
	// セッションを作成
	cfg, err := config.LoadDefaultConfig(context.Background())
	if err != nil {
		Logger(ERROR, err)
		return
	}
	// ECSクラスタと名前と新しいDesired数を指定
	clusterName := TARGET_CLUSTER
	desiredCount := desired

	// ECSサービスを列挙
	svc := ecs.NewFromConfig(cfg)
	resp, err := svc.ListServices(context.Background(), &ecs.ListServicesInput{
		Cluster: &clusterName, // クラスター名を指定します。
	})
	if err != nil {
		Logger(ERROR, err)
		return
	}
	// Update
	for _, arn := range resp.ServiceArns {
		_, err = svc.UpdateService(context.Background(), &ecs.UpdateServiceInput{
			Service:      &arn,
			Cluster:      &clusterName,
			DesiredCount: &desiredCount, // sdkでint32を受け付けている
		})
		if err != nil {
			fmt.Printf("failed to update service{0}: {1}", arn, err)
		}
	}
}

func GetDesired(status interface{}) (int32 , error) {
	if status == "start" {
		return SERVICE_START, nil
	} else if status == "stop" {
		return SERVICE_STOP, nil
	} else {
		return INVALID, errors.New("failed to get input of event.")
	}
}

func HandleRequest(ctx context.Context, event map[string]interface{}) {
	// EventBridgeによって呼び出された入力値からdesiredを決定
	desired, err := GetDesired(event["status"])
	if err != nil {
		Logger(ERROR, err)
		return
	}
	// ECSの更新
	EcsTaskHander(desired)
}

func main() {
	lambda.Start(HandleRequest)
}
